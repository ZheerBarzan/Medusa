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
            // modifer
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
            // modifer
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
    
    var body: some View{
        Text("Folder")
    }
}

private struct CaptureModeGuidanceView: View{
    @Environment(AppDataModel.self) var appModel
    
    var body: some View{
        Text("Capture Mode Guidance")
    }
}


