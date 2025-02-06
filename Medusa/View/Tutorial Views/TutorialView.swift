//
//  TutorialView.swift
//  Medusa
//
//  Created by zheer barzan on 6/2/25.
//

import SwiftUI
import AVFoundation

struct TutorialView: View {
    @Environment(AppDataModel.self) var appModel
    var url : URL
    
    @Binding var tutorialView: Bool
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var isVisible = false
    
    private let delay: TimeInterval = 0.3
    
    private let tutorialAnimationTimeReduced: TimeInterval = 0.2
    
    var body: some View {
        
        VStack{
            Spacer()
            TutorialVideoView(url: url, inReview: false)
                .frame(maxHeight: horizontalSizeClass == .regular ? 300 : 220)
                .overlay(alignment: .bottom){
                    if appModel.captureMode == .object{
                        Text(LocalizedString.tutorialText)
                            .font(.headline)
                            .padding(.bottom, appModel.captureMode == .object ? 16 : 0)
                            .foregroundStyle(.white)
                    }
                }
            Spacer()
        }.opacity(isVisible ? 1 : 0)
            .background(Color.black.opacity(0.5))
            .allowsHitTesting(false)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + delay){
                    appModel.objectCaptureSession?.pause()
                    
                    withAnimation{
                        isVisible = true
                    }
                }
            }.onDisappear{
                appModel.objectCaptureSession?.resume()
            }
            .task {
                let animationDuration = try? await AVURLAsset(url:url).load(.duration).seconds - tutorialAnimationTimeReduced
                DispatchQueue.main.asyncAfter(deadline: .now() + (animationDuration ?? 0)){
                    tutorialView = false
                }
            }
    }
    
    private struct LocalizedString{
        static let tutorialText = NSLocalizedString(
            "Move slowly around your object. (Object Capture, Orbit, Tutorial)",
            bundle: Bundle.main,
            value: "Move slowly around your object.",
            comment: "Tutorial text for object capture mode.")
    }
}

