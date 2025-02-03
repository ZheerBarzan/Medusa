//
//  TimedMessageList.swift
//  Medusa
//
//  Created by zheer barzan on 31/1/25.
//

import SwiftUI

@Observable
class TimedMessageList{
    
    struct Message: Identifiable{
        let id = UUID()
        let message: String
        let startTime: Date
        
        fileprivate(set) var endTime: Date?
        
        init(msg: String, startTime inStartTime: Date = Date()){
            message = msg
            startTime = inStartTime
            endTime = nil
        }
        
        func hasExpired() -> Bool{
            guard let endTime else {
                return false
            }
            return Date() >= endTime
        }
    }
    
    var activeMessage: Message? = nil
    
    private var messages: [Message] = [] {
        didSet{
            dispatchPrecondition(condition: .onQueue(.main))
            let newActiveMessage = !messages.isEmpty ? messages[0] : nil
            
            if activeMessage?.message != newActiveMessage?.message{
                withAnimation{
                    activeMessage = newActiveMessage
                }
            }
        }
    }
    
    private var timer: Timer?
    
    private let feedbackMessageDuration: Double = 3.0
    
    init(){
    }
    
    func add(_ message: String){
        dispatchPrecondition(condition: .onQueue(.main))
        
        if let index = messages.lastIndex(where: {$0.message == message}){
            messages[index].endTime = nil
        }else{
            messages.append(Message(msg: message))
        }
        setTimer()
    }
    
    func removeAll(){
        timer?.invalidate()
        timer = nil
        activeMessage = nil
        messages.removeAll()
    }
    
    func remove(_ message: String){
        dispatchPrecondition(condition: .onQueue(.main))
        
        guard let index = messages.lastIndex(where: {$0.message == message}) else {
            return
        }
        
        var endTime = Date()
        let earliestTimeAllowed = messages[index].startTime + feedbackMessageDuration
        
        if endTime < earliestTimeAllowed{
            endTime = earliestTimeAllowed
        }
        messages[index].endTime = endTime
        setTimer()
    }
    
    private func setTimer(){
        dispatchPrecondition(condition: .onQueue(.main))
        
        timer?.invalidate()
        timer = nil
        
        cullExpired()
        
        if let nearestTime = (messages.compactMap{$0.endTime}.min()){
            
            let duration = nearestTime.timeIntervalSinceNow
            timer = Timer.scheduledTimer(timeInterval: duration,
                                         target: self,
                                         selector: #selector(onTimer),
                                         userInfo: nil,
                                         repeats: false)
        }
    }
    
    private func cullExpired(){
        dispatchPrecondition(condition: .onQueue(.main))
        
        withAnimation{
            messages.removeAll(where: {$0.hasExpired()})
        }
    }
    
    @objc
    private func onTimer(){
        dispatchPrecondition(condition: .onQueue(.main))
        
        timer?.invalidate()
        cullExpired()
        setTimer()
    }
}
