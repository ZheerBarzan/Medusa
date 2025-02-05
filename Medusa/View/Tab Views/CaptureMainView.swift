//
//  CaptureMainView.swift
//  Medusa
//
//  Created by zheer barzan on 4/2/25.
//

import SwiftUI
import RealityKit

struct CaptureMainView: View {
    @Environment(AppDataModel.self) var appModel
    var session: ObjectCaptureSession
    
    
    var body: some View {
        
        VStack(spacing: 0){
            ZStack{
                ObjectCaptureView(session: session, cameraFeedOverlay: { GradientBackground() })
                    .hideObjectReticle(appModel.captureMode == .scene)
                    .blur(radius: appModel.showOverlays ? 45 : 0)
                    .transition(.opacity)
                
                
                
                CaptureSurfaceView(session: session)
                
            }.onAppear(
                perform: {
                    UIApplication.shared.isIdleTimerDisabled = true
                })
        }.id(session.id)
        
    }
}

private struct GradientBackground: View {
    private let gradientBackgroundColor = LinearGradient(
        colors: [.black.opacity(0.2), .clear],
        startPoint: .top,
        endPoint: .bottom
    )
    
    private let frameHeight: CGFloat = 300
    
    var body: some View {
        VStack{
            gradientBackgroundColor
                .frame(height: frameHeight)
            Spacer()
            gradientBackgroundColor
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .frame(height: frameHeight)
        }.padding(.bottom, 30)
            .allowsHitTesting(false)
        
    }
    
}
