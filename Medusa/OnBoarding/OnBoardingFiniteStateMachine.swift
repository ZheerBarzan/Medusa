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
        .tooFewImages: [(inputs: [.continue(isFlippable: true), .continue(isFlippable: false)], destination: .firstSegment)], // too few images
        .firstSegmentNeedsWork: [], // first segment needs work
        .firstSegmentComplete: [], // first segment complete
        .flipObject: [], // flip object
        .flippingObjectNotRecommended: [], // flipping object not recommended
        .captureFromLowerAngle: [], // capture from lower angle
        .secondSegmentNeedsWork: [], // second segment needs work
        .secondSegmentComplete: [], // second segment complete
        .flipObjectASecondTime: [], // flip object a second time
        .captureFromHigherAngle: [], // capture from higher angle
        .thirdSegmentNeedsWork: [], // third segment needs work
        .thirdSegmentComplete: [], // third segment complete
        .captureInAreaMode: [], // capture in area mode
            
    ]// all states and their transitions
    
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
