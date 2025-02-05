//
//  TutorialPageView.swift
//  Medusa
//
//  Created by zheer barzan on 5/2/25.
//

import SwiftUI

struct TutorialPageView: View {
    let pageName: String
    let imageName: String
    let imageCaption: String
    let sections: [Section]
    var body: some View {
        VStack(alignment: .leading){
            Text(pageName)
                .foregroundColor(.primary)
                .font(.title)
                .bold()
            Text(imageCaption)
                .foregroundColor(.secondary)
            HStack{
                Spacer()
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(UIDevice.current.userInterfaceIdiom == .pad ? 1.5 : 1.2)
                Spacer()
            }
            
            SectionView(sections: sections)
        }
        .navigationBarTitle(pageName, displayMode: .inline)
    }
}

