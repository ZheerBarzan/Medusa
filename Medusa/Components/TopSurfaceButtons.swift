//
//  TopSurfaceButtons.swift
//  Medusa
//
//  Created by zheer barzan on 6/2/25.
//

import SwiftUI
import RealityKit


struct TopSurfaceButtons: View, SurfaceButtons{
    @Environment(AppDataModel.self) var appModel
    var session: ObjectCaptureSession
    var captureModeGuidance: Bool
    
    var body: some View{
        VStack{
            HStack{
                CaptureCancelButton()
                Spacer()
                if CaptureStarted(state: session.state){
                    NextButton(session: session)
                }else{
                    CaptureFolderButton()
                }
                
            }.foregroundColor(.white)
            Spacer().frame(height: 25)
            if session.state == .ready, captureModeGuidance{
                CaptureModeGuidanceView()
            }
            
        }
    }
}

private struct CaptureCancelButton: View{
    @Environment(AppDataModel.self) var appModel
    
    var body: some View{
        Button(action: {
            appModel.objectCaptureSession?.cancel()
            appModel.removeCapture()
            
            
        }, label: {
            Text(LocalizedString.cancel)
                .modifier(VisualEffectRoundedCorner())
            
        })
    }
    
    private struct LocalizedString{
        static let cancel = NSLocalizedString(
            "Cancel (Object Capture)",
            bundle: Bundle.main,
            value: "Cancel",
            comment: "Title for the Cancel button on the object capture screen.")
    }
}

private struct NextButton: View{
    @Environment(AppDataModel.self) var appModel
    var session: ObjectCaptureSession
    @State private var onBoardingView: Bool = false
    
    
    var body: some View{
        Button(action: {
            onBoardingView = true
        }, label: {
            Text(appModel.captureMode == .object ? LocalizedString.next : LocalizedString.done)
                .modifier(VisualEffectRoundedCorner())
          
        })
        .sheet(isPresented: $onBoardingView){
            if let onBoardingState = appModel.onboardingState(){
                OnBoardingView(state: onBoardingState, showOnBoardingView: $onBoardingView)
                    .interactiveDismissDisabled()
            }
        }
        .onChange(of: onBoardingView){
            appModel.showOverlaysIfNeeded(to: onBoardingView)
        }
        .task{
            for await userCompletedScanPass in session.userCompletedScanPassUpdates where userCompletedScanPass{
                onBoardingView = true
            }
        }
        
    }
    private struct LocalizedString {
             static let next = NSLocalizedString(
                 "Next (Object Capture)",
                 bundle: Bundle.main,
                 value: "Next",
                 comment: "Title for the Next button on the object capture screen."
             )

             static let done = NSLocalizedString(
                 "Done (Object Capture)",
                 bundle: Bundle.main,
                 value: "Done",
                 comment: "Title for the Done button on the object capture screen."
             )
         }
}


private struct CaptureFolderButton: View{
    @Environment(AppDataModel.self) var appModel
    @State private var showCaptureFolder: Bool = false
    
    var body: some View{
        Button(action: {
            showCaptureFolder = true
        }, label: {
            Image(systemName: "folder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                .padding(20)
                .contentShape(.rect)
        })
        .padding(-20)
        .sheet(isPresented: $showCaptureFolder) {
            
            GallaryView(showCaptures: $showCaptureFolder, isFolderButton: true)
        }
        .onChange(of: showCaptureFolder){
            appModel.showOverlaysIfNeeded(to: showCaptureFolder)
        }
    }
}

private struct CaptureModeGuidanceView: View{
    @Environment(AppDataModel.self) var appModel
    var body: some View{
        Text(guidenceText)
            .font(.subheadline)
            .bold()
            .padding(.all,6)
            .foregroundColor(.white)
            .background(.black)
            .cornerRadius(10)
    }
    private var guidenceText: String{
        switch appModel.captureMode{
        case .scene:
            return LocalizedString.sceneMode
        case .object:
            return LocalizedString.objectMode
        }
        
    }
    
    private struct LocalizedString{
        static let sceneMode = NSLocalizedString(
            "Scene mode (Object Capture)",
            bundle: Bundle.main,
            value: "Scene mode",
            comment: "Guidance text for the Scene mode in object capture.")
        
        static let objectMode = NSLocalizedString(
            "Object mode (Object Capture)",
            bundle: Bundle.main,
            value: "Object mode",
            comment: "Guidance text for the Object mode in object capture.")
    }
    
}

private struct VisualEffectRoundedCorner: ViewModifier {
    func body (content: Content) -> some View {
        content
            .padding(16)
            .font(.headline)
            .bold()
            .foregroundColor(.white)
            .background(.ultraThinMaterial)
            .environment(\.colorScheme, .dark)
            .cornerRadius(15)
            .multilineTextAlignment(.center)
    }
}


