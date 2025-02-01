//
//  AppDataModel.swift
//  Medusa
//
//  Created by zheer barzan on 31/1/25.
//

import RealityKit
import SwiftUI
import os

//private let logger = Logger(subsystem: , category: "AppDataModel")


@MainActor
@Observable
// MARK: - AppDataModel
// This is the brain of the app. It remembers if you’re taking pictures, building the 3D model, or if something went wrong.

class AppDataModel: Identifiable{
    // making a static instase of the app data model so that we can access it from any where in the app
    static let instance = AppDataModel()
    
    // MARK: - Properties
    
    // initalizing the object capture session for the app to keep track of all the photos.
    
    var objectCaptureSession: ObjectCaptureSession? {
        willSet{
            detachListeners()
        } didSet{
            guard objectCaptureSession != nil else { return }
            attachListeners()
        }
    }
    
    static let minimumNumberOfImages = 10
    
    
    // MARK: - Private Properties
    // initalizing the photogrammery session once it goes to reconstrction stage it will be set to nil
    private(set) var photogrammetrySession: PhotogrammetrySession?
    
    // when we start a new session for captureing the folder will be set for the capture folder manager
    private(set) var captureFolderManager: CaptureFolderManager?
    
    // allowing the user to save the reconstruction as a draft or not
    private(set) var isDraftEnabled = false
    
    var messageList = TimedMessageList()
    
    
    // MARK: - States of the capture process
    
    enum ModelCaptureState{
        case notSet
        case ready
        case capturing
        case prepareToReconstruct
        case reconstructing
        case viewing
        case completed
        case restart
        case failed
    }
    
    // The current state of the model, starting with 'notSet'
    var state: ModelCaptureState = .notSet{
        didSet{
            performStateChange(from: oldValue, to: state)
        }
    }
    
    // The current orbit, starting with 'orbit1'
    var orbit: Orbit = .Orbit1
    
    // check weather object is flipped or not
    var isObjectFlipped: Bool = false
    // Flags to indicate if the object can be flipped
    var objectCannotBeFlipped: Bool = false
    var objectCanBeFlippedAnyway: Bool = false
    
    var isObjectFilppable: Bool{
        // If we already said it can't be flipped, return false
        guard !objectCannotBeFlipped else { return false }
        
        // If we already said flip it anyway, return true
        guard !objectCanBeFlippedAnyway else { return true }
        
        // if there is no session return ture
        guard let session = objectCaptureSession else { return true }
        
        return !session.feedback.contains(.objectNotFlippable)
    }
    
    // Modes of Capture for the app
    enum CaptureMode: Equatable{
        case object
        case scene
    }
    
    // current mode of capture
    var captureMode: CaptureMode = .object
    
    
    // The error that caused the state to move to 'failed'
    private(set) var error: Swift.Error?
    
    
    private(set) var showOverlays = false
    
    // Shows whether the tutorial has played once during a session
    var tutorialPlayedOnce = false
    
    
    // Set the initial state to 'ready' and set up the notification to listen for app termination
    private init(){
        state = .ready
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppTermination(notification:)),
            name: UIApplication.willTerminateNotification,
            object: nil)
    }
    
    // Clean up when this object is destroyed
    deinit {
           NotificationCenter.default.removeObserver(self)
           DispatchQueue.main.async {
               self.detachListeners()
           }
       }
    
    /*Once reconstruction and viewing are complete, this should be called to let the app know it can go back to the new capture view.
      We explicitly DO NOT destroy the model here to avoid transition state errors. The splash screen will set up the
      AppDataModel to a clean slate when it starts.
      This can also be called after a cancelled or error reconstruction to go back to the start screen.*/
    func endCapture(){
        state = .completed
    }
    
    // romove the capture from the folder of the app
    func removeCapture(){
        guard let url = captureFolderManager?.captureFolder else { return }
        try? FileManager.default.removeItem(at: url)
    }
    
    // show the overlays if needed when the user is pausing or resuming the app
    func showOverlaysIfNeeded(to shown: Bool){
        guard shown != showOverlays else { return }
        
        if shown{
            showOverlays = true
            objectCaptureSession?.pause()
        }else{
            showOverlays = false
            objectCaptureSession?.resume()
        }
    }
    
    // save the object as a draft
    func saveDraft(){
        objectCaptureSession?.finish()
        isDraftEnabled = true
    }
    
    private var currentFeedback: Set<Feedback> = []
    
    private typealias Feedback = ObjectCaptureSession.Feedback
    private typealias Tracking = ObjectCaptureSession.Tracking
    
    
    // the set of tasks that are running in the app
    private var tasks: [ Task<Void,Never> ] = []
}


extension AppDataModel{
    
    // MARK: - Functions
    private func attachListeners(){
    }
    private func detachListeners(){
    }
    @objc
    private func handleAppTermination(notification: Notification){
        if state == .ready || state == .capturing{
            removeCapture()
            }
        }
        private func startNewCaptureSession() throws{
        }
        
        private func startObjectReconstruction() throws{
        }
        private func switchToErrorState(error inError: Swift.Error){
            state = .failed
            error = inError
        }
        
        private func resetCapture(){
        }
        
        
        // this function is used to change the state of the app from one state to another
        private func performStateChange(from fromState: ModelCaptureState, to toState: ModelCaptureState){
            if fromState == toState {return}
            if toState == .failed { error = nil}
            
            switch toState{
            case .ready:
                do{
                    try startNewCaptureSession()
                }catch{
                    state = .failed
                }
            case .prepareToReconstruct:
                objectCaptureSession = nil
                do{
                    try startObjectReconstruction()
                }catch{
                    switchToErrorState(error: error)
                }
            case .restart, .completed:
                resetCapture()
            case .viewing:
                photogrammetrySession = nil
                removeCheckpoint()
            case .failed:
                // TODO: show error screen
                state = .failed
            default:
                break
            }
        }
        
        private func removeCheckpoint(){
        }
    }
