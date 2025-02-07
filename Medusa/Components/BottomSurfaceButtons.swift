//
//  BottomSurfaceButtons.swift
//  Medusa
//
//  Created by zheer barzan on 7/2/25.
//

import SwiftUI
import RealityKit

struct BottomSurfaceButtons: View {
    @Environment(AppDataModel.self) var appModel
    var session : ObjectCaptureSession
    @Binding var detectionFailed: Bool
    @Binding var captureModeGuidence: Bool
    @Binding var TutorialView: Bool
    
    var rotationAngle: Angle
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


@MainActor
private struct CaptureButton: View{
    @Environment(AppDataModel.self) var appModel
    var session: ObjectCaptureSession
    @Binding var detectionFailed: Bool
    @Binding var captureModeGuidence: Bool
    
    var body: some View{
        Text("Capture")
    }
}


private struct AutoDetectionView: View{
    var session: ObjectCaptureSession
    
    var body: some View{
        Text("Auto Detection")
    }
}

private struct ResetBoundingBoxButton: View{
    @Environment(AppDataModel.self) var appModel
    var session: ObjectCaptureSession
    
    
    var body: some View{
        Text("Reset Bounding Box")
    }
    

}

private struct ManualShotButton: View{
    var session: ObjectCaptureSession
    
    var body: some View{
        
        Text("Manual Shot")
        
    }
    
}


private struct HelpButton : View {
    @Environment(AppDataModel.self) var appModel
    @State private var showHelpPageView: Bool = false
    
    
    var body: some View {
        Text("Help")
    }
}

private struct CaptureModeButton: View {
    @Environment(AppDataModel.self) var appModel
    var session: ObjectCaptureSession
    @Binding var captureModeGuidence: Bool
    @State private var captureModeGuidanceTimer: Timer? = nil
    
    var body: some View{
        Text("Capture Mode")
    }
}

private struct NumOfImagesButton: View{
    var session: ObjectCaptureSession
    @State private var info: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View{
        Text("Number of Images")
        
    }
}

private struct AutoCaptureToggleButton: View{
    var session: ObjectCaptureSession
    
    var body: some View{
        
        Text("Auto Capture")
    }
}


