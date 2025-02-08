//
//  CaptureFolderManager.swift
//  Medusa
//
//  Created by zheer barzan on 31/1/25.
//

import Foundation

@Observable
final class CaptureFolderManager: Sendable{
    
    //MARK: - Properties
    enum Error: Swift.Error {
        case noObjectURL
        case objectCreationFailed
        case objectAlreadyExists
        case objectURLInvalid
    }
    
    // The app's documents folder that includes captures from all sessions.
    let appDocumentFolder: URL = URL.documentsDirectory
    
    // capture directory that contains imagesFolder, checkpointFolder, and modelsFolder.
    // Automatically created at init() with timestamp.
    let captureFolder: URL
    
    // Subdirectory of captureFolder to store the reconstruction checkpoint.
    let checkpointFolder: URL
    
    // Subdirectory of captureFolder to store the images.
    let imagesFolder: URL
    
    // Subdirectory of captureFolder to store the created model.
    let modelsFolder: URL

    static let imageFolderName = "Images/"
    

    init() throws{
        guard let newFolder = CaptureFolderManager.createNewCaptureFolder() else {
            throw Error.objectCreationFailed
        }
        
        captureFolder = newFolder
        
        // Create subdirectories
        imagesFolder = newFolder.appendingPathComponent(Self.imageFolderName)
        try CaptureFolderManager.createFolderRecursively(inFolder: imagesFolder)
        
        checkpointFolder = newFolder.appendingPathComponent("Checkpoints/")
        try CaptureFolderManager.createFolderRecursively(inFolder: checkpointFolder)
        
        modelsFolder = newFolder.appendingPathComponent("Models/")
        try CaptureFolderManager.createFolderRecursively(inFolder: modelsFolder)
        
    }
    
    //MARK: - Methods
    
    // Creates a new folder for the capture session.
    private static func createNewCaptureFolder() -> URL?{
        
        let formatter = ISO8601DateFormatter()
        let timestamp = formatter.string(from: Date())
        
        let newCaptureFolder = URL.documentsDirectory.appendingPathComponent(timestamp, isDirectory: true)
        
        let captureFolderPath = newCaptureFolder.path
        
        do{
            try FileManager.default.createDirectory(atPath: captureFolderPath, withIntermediateDirectories: true)
            
        }catch{
            return nil
        }
        
        var isFolder: ObjCBool = false
        let DoesExist = FileManager.default.fileExists(atPath: captureFolderPath, isDirectory: &isFolder)
        
        guard DoesExist && isFolder.boolValue else {
            return nil
        }
        return newCaptureFolder
    }
    
    
    // creates all path components in the given folder URL if they do not exist.
    private static func createFolderRecursively(inFolder folder: URL) throws{
        guard folder.isFileURL else {
            throw CaptureFolderManager.Error.objectURLInvalid
        }
        
        let fullPath = folder.path
        var isFolder: ObjCBool = false
        
        guard !FileManager.default.fileExists(atPath: folder.path, isDirectory: &isFolder) else {
            throw CaptureFolderManager.Error.objectAlreadyExists
        }
        
        try FileManager.default.createDirectory(atPath: fullPath, withIntermediateDirectories: true)
        
        var isValidFolder: ObjCBool = false
        
        guard FileManager.default.fileExists(atPath: fullPath, isDirectory: &isValidFolder) && isValidFolder.boolValue else {
            throw CaptureFolderManager.Error.objectCreationFailed
        }
    }
    
    //MARK: - file types
    
    private static let imageNamePrefix = "IMG_"
    private static let imageExtension = "HEIC"
}
