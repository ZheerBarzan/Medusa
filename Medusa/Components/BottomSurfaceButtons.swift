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
        Button(action:{
            performAction()
        }, label: {
            Text(captureButtonLabel)
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 20)
                .padding(.horizontal, 25)
                .background(Color.blue)
                .cornerRadius(15)
        })
    }
    
    private var captureButtonLabel: String{
        if session.state == .ready{
            switch appModel.captureMode{
            case .object:
                return LocalizedString.continue
            case .scene:
                return LocalizedString.startCapture
                
            }
            
        }else{
            if !appModel.isObjectFlipped{
                return LocalizedString.startCapture
            }else{
                return LocalizedString.continue
            }
        }
    }
    
    private func performAction(){
        if session.state == .ready{
            switch appModel.captureMode{
            case .object:
                detectionFailed = !(session.startDetecting())
            case .scene:
                session.startCapturing()
            }
        }else if case .detecting = session.state{
            session.startCapturing()
        }
    }
    
    struct LocalizedString{
        static let startCapture = NSLocalizedString(
            "Start Capture (Object Capture)",
            bundle: Bundle.main,
            value: "Start Capture",
            comment: "Title for the Start Capture button on the object capture screen.")
        
        static let `continue` = NSLocalizedString(
            "Continue (Object Capture, Capture)",
            bundle: Bundle.main,
            value: "Continue",
            comment: "Title for the Continue button on the object capture screen.")
        
    }
}


private struct AutoDetectionView: View{
    var session: ObjectCaptureSession
    
    var body: some View{
        VStack(spacing: 6){
            let imageName = session.feedback.contains(.objectNotDetected) ? "eye.slash.circle" : "eye.circle"
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(5)
                .frame(width: 30)
            if UIDevice.current.userInterfaceIdiom == .pad{
                let text = session.feedback.contains(.objectNotDetected) ? "Object Not Detected" : "Object Detected"
                Text(text)
                    .frame(width: 90)
                    .font(.footnote)
                    .opacity(0.7)
                    .fontWeight(.semibold)
            }
        }
        .foregroundColor(.white)
        .fontWeight(.semibold)
        .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 0 : 15)
    }
}

private struct ResetBoundingBoxButton: View{
    @Environment(AppDataModel.self) var appModel
    var session: ObjectCaptureSession
    
    
    var body: some View{
        Button(action:{
            session.resetDetection()
        }, label: {
            VStack(spacing: 6){
                
                Image(systemName: "arrow.counterclockwise")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                
                if UIDevice.current.userInterfaceIdiom == .pad{
                    Text(LocalizedString.resetBox)
                        .font(.footnote)
                        .opacity(0.7)
                }
            }
            .foregroundColor(.white)
            .fontWeight(.semibold)
        })
        .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 0 : 15)
    }
    
    struct LocalizedString {
        static let resetBox = NSLocalizedString(
            "Reset Box (Object Capture)",
            bundle: Bundle.main,
            value: "Reset Box",
            comment: "Title for the Reset Box button on the object capture screen."
        )
    }
}

private struct ManualShotButton: View{
    var session: ObjectCaptureSession
    
    var body: some View{
        
        Button(action: {
            session.requestImageCapture()
            
        }, label: {
            Text(Image(systemName: "button.programmable"))
                .font(.largeTitle)
                .foregroundColor(session.canRequestImageCapture ? .white : .gray)
            
        })
        .disabled(!session.canRequestImageCapture)
    }
}


private struct HelpButton : View {
    @Environment(AppDataModel.self) var appModel
    @State private var showHelpPageView: Bool = false
    
    
    var body: some View {
        Button(action: {
            
            withAnimation{
                showHelpPageView = true
            }
            
        }, label: {
            Image(systemName: "questionmark.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22)
                            .foregroundColor(.white)
                            .padding(20)
                            .contentShape(.rect)
        })
        .padding(-20)
        .sheet(isPresented: $showHelpPageView){
            HelpPageView(showHelpPage: $showHelpPageView).padding()
        }
        .onChange(of: showHelpPageView){
            appModel.setOverlaySheets(to: showHelpPageView)
        }
    }
    struct LocalizedString {
        static let help = NSLocalizedString(
            "Help (Object Capture)",
            bundle: Bundle.main,
            value: "Help",
            comment: "Title for the Help button on the object capture screen to show the tutorial pages.")
    }
}

private struct CaptureModeButton: View {
    @Environment(AppDataModel.self) var appModel
    var session: ObjectCaptureSession
    @Binding var captureModeGuidence: Bool
    @State private var captureModeGuidanceTimer: Timer? = nil
    
    var body: some View{
        Button(action: {
           
            CaptureModeSwitchAction()
                
        }, label: {
            
            VStack{
                switch appModel.captureMode{
                case .object:
                    Image(systemName: "cube")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .scene:
                    // Image(systemName: "circle.dashed")
                    Image(systemName: "camera.viewfinder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 30)
            .foregroundStyle(.white)
            .padding(20)
            .contentShape(.rect)
            
        })
        .padding(-20)
    }
    
    private func CaptureModeSwitchAction(){
        switch appModel.captureMode{
        case .object:
            DispatchQueue.main.async {
                appModel.captureMode = .scene
            }
        case .scene:
            DispatchQueue.main.async {
                appModel.captureMode = .object
            }
        }
        withAnimation{
            captureModeGuidence = true
        }
        
        if captureModeGuidanceTimer != nil{
            captureModeGuidanceTimer?.invalidate()
            captureModeGuidanceTimer = nil
        }
        
        captureModeGuidanceTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false){ _ in
            withAnimation{
                captureModeGuidence = false
            }
        }
    }
}

private struct NumOfImagesButton: View{
    var session: ObjectCaptureSession
    @State private var info: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View{
        Text("Number of Images")
        
    }
    
    struct LocalizedString {
        static let numOfImages = NSLocalizedString(
            "%d/%d (Format, # of Images)",
            bundle: Bundle.main,
            value: "%d/%d",
            comment: "Images taken over maximum number of images.")
        static let photoLimit = NSLocalizedString(
            "Photo limit (Object Capture)",
            bundle: Bundle.main,
            value: "Photo limit",
            comment: "Title for photo limit popover.")
        static let createModelLimits = NSLocalizedString(
            "To create a model on device you need a minimum of %d images and a maximum of %d images. (Object Capture)",
            bundle: Bundle.main,
            value: "To create a model on device you need a minimum of %d images and a maximum of %d images.",
            comment: "Text to explain the photo limits in object capture.")
        static let captureMore = NSLocalizedString(
            "You can capture more than %d images and process them on your Mac. (Object Capture)",
            bundle: Bundle.main,
            value: "You can capture more than %d images and process them on your Mac.",
            comment: "Text to explain the photo limit in object capture.")
    }
}

private struct AutoCaptureToggleButton: View{
    var session: ObjectCaptureSession
    
    var body: some View{
        
        Text("Auto Capture")
    }
}


