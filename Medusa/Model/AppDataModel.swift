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
    
    
    
    
    
    
    
    
    
    
}
