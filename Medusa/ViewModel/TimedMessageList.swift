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
            
            
            
    }
    
    
    func add(_ message: String){
        // TODO: Implement add
    }
    func removeAll(){
    // TODO: Implement removeAll
    
    }
    
    func remove(_ message: String){
        // TODO: Implement
    }
    
}
