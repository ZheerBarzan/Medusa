//
//  CirculerProgressBar.swift
//  Medusa
//
//  Created by zheer barzan on 4/2/25.
//

import SwiftUI

struct CirculerProgressBar: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        VStack{
            Spacer()
            ZStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .light ? .black : .white))
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    CirculerProgressBar()
}
