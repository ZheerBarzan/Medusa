//
//  CaptureSurfaceView.swift
//  Medusa
//
//  Created by zheer barzan on 5/2/25.
//

import SwiftUI
import RealityKit
import AVFoundation

struct CaptureSurfaceView: View {
    @Environment(AppDataModel.self) var appModel
    var session: ObjectCaptureSession
    
    
    @AppStorage("show_tutorial") var enableTutorial: Bool = true
    
    @State private var captureModeGuidance: Bool = false
    @State private var detectionFailed: Bool = false
    @State private var tutorialView : Bool = false
    @State private var deviceOrientation: UIDeviceOrientation = UIDevice.current.orientation
    
    var body: some View {
        ZStack{
            if enableTutorial, tutorialView , let url = tutorialURL{
                TutorialView(url: url, tutorialView: $tutorialView)
            }else{
                VStack(spacing: 20){
                    // TopSurfaceButtons(session: session, captureModeGuidence: $captureModeGuidence)
                    
                    Spacer()
                    
                    // GuidenceBox(session: session, detectionFailed: detectionFailed)
                    
                   // BottomSurfaceButtons(session: session,hasDetectionFailed: $hasDetectionFailed, showCaptureModeGuidance: $showCaptureModeGuidance,showTutorialView: $showTutorialView, rotationAngle: rotationAngle)
                }
                .padding()
                .padding(.horizontal,20)
                .background{
                    VStack{
                        Spacer().frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 70 : 30)
                        
                        FeedbackView(messageList: appModel.messageList).layoutPriority(1)
                        
                    }
                    .rotationEffect(rotationAngle)
                }
                .task{
                    for await _ in NotificationCenter.default.notifications(named: UIDevice.orientationDidChangeNotification){
                        withAnimation{
                            deviceOrientation = UIDevice.current.orientation
                        }
                    }
                }
            }
        }
        .opacity(shouldShowSurfaceView ? 1 : 0)
        .onChange(of: session.state){
            if !appModel.tutorialPlayedOnce, session.state == .capturing{
                withAnimation{
                    tutorialView = true
                }
                appModel.tutorialPlayedOnce = true
            }
        }
    }
    
    private var shouldShowSurfaceView: Bool {
        return tutorialView || (session.cameraTracking == .normal && !session.isPaused)
    }
    
    private var tutorialURL: URL? {
        let interfaceIdiom = UIDevice.current.userInterfaceIdiom
        var videoName: String? = nil
        
        switch appModel.captureMode {
        case .scene:
            videoName = interfaceIdiom == .pad ? "scene_tutorial_iPad" : "scene_tutorial_iPhone"
        case .object:
            videoName = interfaceIdiom == .pad ? "object_tutorial_iPad" : "object_tutorial_iPhone"
        }
        guard let videoName = videoName else { return nil }
        
        return Bundle.main.url(forResource: videoName, withExtension: "mp4")
    }
    
    private var rotationAngle: Angle {
        switch deviceOrientation {
            case .landscapeLeft:
                return Angle(degrees: 90)
            case .landscapeRight:
                return Angle(degrees: -90)
            case .portraitUpsideDown:
                return Angle(degrees: 180)
            default:
                return Angle(degrees: 0)
        }
        
    }
}
