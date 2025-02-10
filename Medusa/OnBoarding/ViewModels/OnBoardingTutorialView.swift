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
        VStack{
            let frameSize = min(viewSize.width, viewSize.height) * (UIDevice.current.userInterfaceIdiom == .pad ? 0.6 : 0.8)
            switch appModel.captureMode {
            case .object:
                ZStack{
                    if showTutorialInReview, let url = tutorialURL{
                        TutorialVideoView(url: url, inReview: true)
                    }else{
                        VStack{
                            Spacer()
                            ObjectCapturePointCloudView(session: session)
                                .showShotLocations()
                            Spacer()
                        }
                    }
                    
                    VStack{
                        Spacer()
                        HStack{
                            ForEach(AppDataModel.Orbit.allCases){ orbit in
                                if let orbitImageName = getOrbitImageName(orbit: orbit){
                                    Text(Image(systemName: orbitImageName))
                                        .font(.system(size: 30))
                                        .foregroundColor(.gray)
                                    
                                }
                            }
                            
                        }
                    }
                    
                    
                }.frame(width: frameSize, height: frameSize)
                
            case .scene:
                Spacer().frame(height: 50)
                ObjectCapturePointCloudView(session: session)
                    .showShotLocations( shotLocations)
                    .frame(width: frameSize, height: frameSize)
            }
            VStack{
                Text(title)
                    .font(.title)
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.4)
                    .bold()
                    .padding(.bottom)
                    .frame(maxWidth: .infinity)
                
                Text(detail)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                Spacer()
                
                if appModel.captureMode == .scene{
                    Text(LocalizedString.estimatedProcessingTime)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    if let numberOfShotsTaken = appModel.objectCaptureSession?.numberOfShotsTaken,
                       let maximumNumberOfShots = appModel.objectCaptureSession?.maximumNumberOfInputImages,
                       numberOfShotsTaken > maximumNumberOfShots{
                        Text(String(format: LocalizedString.transferToMacGuidance,
                                    maximumNumberOfShots, numberOfShotsTaken))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
                    Spacer().frame(height: 130)
                    
                }
                
            }
            .foregroundColor(.primary)
            .frame(maxHeight: .infinity)
            .padding([.leading, .trailing], UIDevice.current.userInterfaceIdiom == .pad ? 50 : 30)
        }
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
        .flipObject: "ScanPasses-iPhone-FixedHeight-2",
        .flipObjectASecondTime: "ScanPasses-iPhone-FixedHeight-3",
        .captureFromLowerAngle: "ScanPasses-iPhone-FixedHeight-unflippable-low",
        .captureFromHigherAngle: "ScanPasses-iPhone-FixedHeight-unflippable-high"    ]
    
    private let onBoardingStateTutorialOnIpad: [ OnboardingState: String ] = [
        .flipObject: "ScanPasses-iPad-FixedHeight-2",
        .flipObjectASecondTime: "ScanPasses-iPad-FixedHeight-3",
        .captureFromLowerAngle: "ScanPasses-iPad-FixedHeight-unflippable-low",
        .captureFromHigherAngle: "ScanPasses-iPad-FixedHeight-unflippable-high"    ]
    
    private var tutorialURL: URL?{
        let videoName : String
        if UIDevice.current.userInterfaceIdiom == .pad{
            videoName = onBoardingStateTutorialOnIpad[onBoardingFSM.currentState] ?? "ScanPasses-iPad-FixedHeight-1"
        }else{
            videoName = onBoardingStateTutorialOnIphone[onBoardingFSM.currentState] ?? "ScanPasses-iPhone-FixedHeight-1"
            
        }
        
        return Bundle.main.url(forResource: videoName, withExtension: "mp4")
        
    }
    
    private func getOrbitImageName(orbit: AppDataModel.Orbit) -> String? {
        guard let session = appModel.objectCaptureSession else { return nil }
        let orbitCompleted = session.userCompletedScanPass
        let orbitCompleteImage = orbit <= appModel.orbit ? orbit.imageSelected : orbit.image
        let orbitInCompleteImage = orbit < appModel.orbit ? orbit.imageSelected : orbit.image
        return orbitCompleted ? orbitCompleteImage : orbitInCompleteImage
    }
    
    private let onboardingStateToTitle: [ OnboardingState: String ] = [
        .tooFewImages: LocalizedString.tooFewImagesTitle,
        .firstSegmentNeedsWork: LocalizedString.firstSegmentNeedsWorkTitle,
        .firstSegmentComplete: LocalizedString.firstSegmentCompleteTitle,
        .secondSegmentNeedsWork: LocalizedString.secondSegmentNeedsWorkTitle,
        .secondSegmentComplete: LocalizedString.secondSegmentCompleteTitle,
        .thirdSegmentNeedsWork: LocalizedString.thirdSegmentNeedsWorkTitle,
        .thirdSegmentComplete: LocalizedString.thirdSegmentCompleteTitle,
        .flipObject: LocalizedString.flipObjectTitle,
        .flipObjectASecondTime: LocalizedString.flipObjectASecondTimeTitle,
        .flippingObjectNotRecommended: LocalizedString.flippingObjectNotRecommendedTitle,
        .captureFromLowerAngle: LocalizedString.captureFromLowerAngleTitle,
        .captureFromHigherAngle: LocalizedString.captureFromHigherAngleTitle,
        .captureInAreaMode: LocalizedString.captureInAreaModeTitle
    ]
    
    private var title: String {
        onboardingStateToTitle[onBoardingFSM.currentState] ?? ""
    }
    
    private let onboardingStateToDetail: [ OnboardingState: String ] = [
        .tooFewImages: String(format: LocalizedString.tooFewImagesDetailText, AppDataModel.minimumNumberOfImages),
        .firstSegmentNeedsWork: LocalizedString.firstSegmentNeedsWorkDetailText,
        .firstSegmentComplete: LocalizedString.firstSegmentCompleteDetailText,
        .secondSegmentNeedsWork: LocalizedString.secondSegmentNeedsWorkDetailText,
        .secondSegmentComplete: LocalizedString.secondSegmentCompleteDetailText,
        .thirdSegmentNeedsWork: LocalizedString.thirdSegmentNeedsWorkDetailText,
        .thirdSegmentComplete: LocalizedString.thirdSegmentCompleteDetailText,
        .flipObject: LocalizedString.flipObjectDetailText,
        .flipObjectASecondTime: LocalizedString.flipObjectASecondTimeDetailText,
        .flippingObjectNotRecommended: LocalizedString.flippingObjectNotRecommendedDetailText,
        .captureFromLowerAngle: LocalizedString.captureFromLowerAngleDetailText,
        .captureFromHigherAngle: LocalizedString.captureFromHigherAngleDetailText,
        .captureInAreaMode: LocalizedString.captureInAreaModeDetailText        ]
    
    private var detail: String {
        onboardingStateToDetail[onBoardingFSM.currentState] ?? ""
    }
}
