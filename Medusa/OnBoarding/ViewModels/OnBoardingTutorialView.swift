//
//  OnBoardingTutorialView.swift
//  Medusa
//
//  Created by zheer barzan on 3/2/25.
//

import SwiftUI
import RealityKit

struct OnBoardingTutorialView: View {
    @Environment(AppDataModel.self) var appModel
    var session : ObjectCaptureSession
    var onBoardingFSM: OnBoardingFiniteStateMachine
    @Binding var shotLocations: Bool
    var viewSize: CGSize
    
    var body: some View {
        Text("OnBoarding Tutorial View")
    }
    
    
    private var showTutorialInReview: Bool {
        switch onBoardingFSM.currentState {
        case .flipObject, .flipObjectASecondTime , .captureFromLowerAngle, .captureFromHigherAngle:
            return true
        default:
            return false
            
        }
    }
    
    private let onBoardingStateTutorialOnIphone: [ OnboardingState: String ] = [
        .flipObject: "Flip the object",
    ]
    
    private let onBoardingStateTutorialOnIpad: [ OnboardingState: String ] = [
        .flipObject: "Flip the object",
    ]
    
    private var tutorialURL: URL?{
        return nil
    }
    
    private func getOrbitImageName(orbit: AppDataModel.Orbit) -> String {
        return ""
    }
    
    private let onboardingStateToTitleMap: [ OnboardingState: String ] = [
        .tooFewImages: LocalizedString.tooFewImagesTitle,

        ]
    
    private var title: String {
        return ""
    }
    
    private let onboardingStateToDetail: [ OnboardingState: String ] = [
        .tooFewImages: String(format: LocalizedString.tooFewImagesDetailText, AppDataModel.minimumNumberOfImages),
        ]

    private var detail: String {
        return ""
    }
}
