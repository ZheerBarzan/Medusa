//
//  OnBoardingView.swift
//  Medusa
//
//  Created by zheer barzan on 6/2/25.
//

import SwiftUI

struct OnBoardingView: View {
    @Environment(AppDataModel.self) var appModel
    private var stateMachine: OnBoardingFiniteStateMachine
    @Binding private var onBoardingView: Bool
    @State private var shotLocations: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    
    init(state: OnboardingState, showOnBoardingView: Binding<Bool>) {
        stateMachine = OnBoardingFiniteStateMachine(state)
        _onBoardingView = showOnBoardingView
    }
    var body: some View {
        GeometryReader{ geometryReader in
            ZStack{
                Color(colorScheme == .light ? .white : .black).ignoresSafeArea()
                if let session = appModel.objectCaptureSession{
                    OnBoardingTutorialView( session: session, onBoardingFSM: stateMachine, shotLocations: $shotLocations, viewSize: geometryReader.size)
                    
                    OnBoardingButtonView(session: session, onBoardingFSM: stateMachine, onBoardingView: $onBoardingView, shotLocation: $shotLocations)
                }
                    
            }
            .allowsHitTesting(!isFinishingOrCompleted)
            
            
        }
    }
    
    private var isFinishingOrCompleted: Bool {
        guard let session = appModel.objectCaptureSession else { return true }
        return session.state == .finishing || session.state == .completed
    }
}

