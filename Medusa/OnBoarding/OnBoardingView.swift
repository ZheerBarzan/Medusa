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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

