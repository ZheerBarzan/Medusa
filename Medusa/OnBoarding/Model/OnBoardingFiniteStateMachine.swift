//
//  OnBoardingFiniteStateMachine.swift
//  Medusa
//
//  Created by zheer barzan on 1/2/25.
//

import Foundation

@Observable
class OnBoardingFiniteStateMachine {
    var currentState: OnboardingState
    
    init(_ state: OnboardingState = .firstSegment) {
        guard initalStates.contains(state) else {
            currentState = .firstSegment
            return
        }
        currentState = state
    }
    
    func enter(_ input: OnboardingUserInput) throws{
        let transitions = try transitions(for: currentState)
        guard let destinationState = transitions.first(where: { $0.inputs.contains(where: { $0 == input }) })?.destination else {
            throw OnboardingError.invalidTransition(from: currentState, to: input)
        }
        currentState = destinationState
    }
    
    func currentUserInput() -> [OnboardingUserInput] {
        let transitions = try? transitions(for: currentState)
        return transitions?.reduce([], { $0 + $1.inputs}) ?? []
        
    }
    
    func reset(to state: OnboardingState) throws {
        guard initalStates.contains(state) else {
            throw OnboardingError.invalidIntialState(state: state)
        }
        currentState = state
    }
    
    // allowed initla stages
    private let initalStates: [OnboardingState] = [
        .tooFewImages,
        .firstSegmentNeedsWork,
        .firstSegmentComplete,
        .secondSegmentNeedsWork,
        .secondSegmentComplete,
        .thirdSegmentNeedsWork,
        .thirdSegmentComplete,
        .captureInAreaMode
    ]
    
    // State transitions based on the user input.
    private let transitions: [OnboardingState: [(inputs: [OnboardingUserInput], destination: OnboardingState)]] = [
        .tooFewImages: [(inputs: [.continue(isFlippable: true), .continue(isFlippable: false)], destination: .firstSegment)],
    
        .firstSegmentNeedsWork: [(inputs: [.continue(isFlippable: true), .continue(isFlippable: false)], destination: .firstSegment),
                                     (inputs: [.skip(isFlippable: true)], destination: .flipObject),
                                     (inputs: [.skip(isFlippable: false)], destination: .flippingObjectNotRecommended)],
        
        .firstSegmentComplete: [(inputs: [.finish], destination: .reconstruction),
                                    (inputs: [.continue(isFlippable: true)], destination: .flipObject),
                                    (inputs: [.continue(isFlippable: false)], destination: .flippingObjectNotRecommended)],
        
        .flipObject: [(inputs: [.continue(isFlippable: true), .continue(isFlippable: false)], destination: .secondSegment),
                          (inputs: [.objectCannotBeFlipped], destination: .captureFromLowerAngle)],
        
        .flippingObjectNotRecommended: [(inputs: [.continue(isFlippable: true), .continue(isFlippable: false)], destination: .captureFromLowerAngle),
                                            (inputs: [.flipObjectAnyway], destination: .flipObject)],
        
        .captureFromLowerAngle: [(inputs: [.finish], destination: .reconstruction),
                                     (inputs: [.continue(isFlippable: true), .continue(isFlippable: false)],
                                      destination: .additionalOrbitOnCurrentSegment)],
        
        .secondSegmentNeedsWork: [(inputs: [.continue(isFlippable: true), .continue(isFlippable: false)], destination: .dismiss),
                                      (inputs: [.skip(isFlippable: true)], destination: .flipObjectASecondTime),
                                      (inputs: [.skip(isFlippable: false)], destination: .captureFromHigherAngle)],
        
        .secondSegmentComplete: [(inputs: [.continue(isFlippable: true)], destination: .flipObjectASecondTime),
                                     (inputs: [.continue(isFlippable: false)], destination: .captureFromHigherAngle)],
        
        .flipObjectASecondTime: [(inputs: [.finish], destination: .reconstruction),
                                     (inputs: [.continue(isFlippable: true), .continue(isFlippable: false)], destination: .thirdSegment)],
        
        .captureFromHigherAngle: [(inputs: [.finish], destination: .reconstruction),
                                      (inputs: [.continue(isFlippable: true), .continue(isFlippable: false)],
                                       destination: .additionalOrbitOnCurrentSegment)],
        
        .thirdSegmentNeedsWork: [(inputs: [.finish], destination: .reconstruction),
                                     (inputs: [.continue(isFlippable: true), .continue(isFlippable: false)], destination: .dismiss)],
        
        .thirdSegmentComplete: [(inputs: [.finish], destination: .reconstruction)],
        
        .captureInAreaMode: [(inputs: [.finish], destination: .reconstruction),
                                 (inputs: [.saveDraft], destination: .dismiss)]
    ]
    
    private func transitions(for state: OnboardingState) throws -> [(inputs: [OnboardingUserInput], destination: OnboardingState)]{
        guard let transitions = transitions[state] else {
            throw OnboardingError.transitionDoesNotExist(for: state)
        }
        return transitions
    }
}

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
enum OnboardingUserInput: Equatable {
    case `continue`(isFlippable: Bool)
    case skip(isFlippable: Bool)
    case finish
    case objectCannotBeFlipped
    case flipObjectAnyway
    case saveDraft
}

enum OnboardingError: Error{
    case transitionDoesNotExist(for: OnboardingState)
    case invalidTransition(from: OnboardingState, to: OnboardingUserInput?)
    case invalidIntialState(state: OnboardingState)
    
}
