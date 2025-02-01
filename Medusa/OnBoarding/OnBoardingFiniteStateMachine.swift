//
//  OnBoardingFiniteStateMachine.swift
//  Medusa
//
//  Created by zheer barzan on 1/2/25.
//

import Foundation

@Observable
class OnBoardingFiniteStateMachine {
    
    enum OnboardingState: Equatable, Hashable {
        case dismiss
        case tooFewImages
        case firstSegment
        case firstSegmentNeedsWork
        case firstSegmentComplete
        case secondSegment
        case secondSegmentNeedsWork
        case secondSegmentComplete
        case thirdSegment
        case thirdSegmentNeedsWork
        case thirdSegmentComplete
        case flipObject
        case flipObjectASecondTime
        case flippingObjectNotRecommended
        case captureFromLowerAngle
        case captureFromHigherAngle
        case reconstruction
        case additionalOrbitOnCurrentSegment
        case captureInAreaMode
    }
}
