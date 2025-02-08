//
//  TutorialVideoView.swift
//  Medusa
//
//  Created by zheer barzan on 5/2/25.
//

import SwiftUI

struct TutorialVideoView: View {
    @Environment(AppDataModel.self) var appModel
    let url: URL
    let inReview: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack(spacing: 0){
            PlayerView(url: url, isInverted: (colorScheme == .light && inReview) ? true: false)
            
            if inReview{
                Spacer(minLength: 28)
            }
        }
        .foregroundColor(.white)
    }
}

