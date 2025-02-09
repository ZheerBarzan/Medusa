//
//  OnBoardingButtonView.swift
//  Medusa
//
//  Created by zheer barzan on 3/2/25.
//


import SwiftUI
import RealityKit


struct OnBoardingButtonView: View {
    @Environment(AppDataModel.self) var appModel
    var session: ObjectCaptureSession
    var onBoardingFSM: OnBoardingFiniteStateMachine
    @Binding var onBoardingView: Bool
    @Binding var shotLocation: Bool
    
    @State private var userHasIndicatedObjectCannotBeFlipped: Bool? = nil
    @State private var userHasIndicatedFlipObjectAnyway: Bool? = nil
    
    
    var body: some View {
        Text("OnBoarding Button View")
    }
    
    
    private var tutorialPlaying: Bool {
        switch onBoardingFSM.currentState {
        case .flipObject, .flipObjectASecondTime, .captureFromLowerAngle, .captureFromHigherAngle:
            return true
        default:
            return false
        }
    }
    
    private func reloadData(){
        
    }
    
    private func newOrbit(){
        
    }
    
    private func transition(with input: OnboardingUserInput){
        
    }
}


private struct CreateButton: View {
    var body: some View {
        Text("Create Button")
    }
}


private struct CancelButton : View {
    var body: some View {
        Text("Cancel Button")
    }
}


private struct CameraToggleButton: View {
    
    var body: some View {
        Text("Camera Toggle Button")
    }
}
