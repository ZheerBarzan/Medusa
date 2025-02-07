//
//  LibraryView.swift
//  Medusa
//
//  Created by zheer barzan on 31/1/25.
//

import SwiftUI

struct LibraryView: View {
    @Environment(AppDataModel.self) var appModel
    @State private var showCapture: Bool = true

    var body: some View {
        NavigationView{
            GallaryView(showCaptures: $showCapture, isFolderButton: false)
                .navigationTitle("Library")
                .font(.system(.headline, design: .monospaced))
                .foregroundColor(.black)
        }
    }
}

#Preview {
    LibraryView()
}
