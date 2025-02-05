//
//  LibraryView.swift
//  Medusa
//
//  Created by zheer barzan on 31/1/25.
//

import SwiftUI

struct LibraryView: View {
    @Environment(AppDataModel.self) var appModel

    var body: some View {
        NavigationView{
            Text("Library")
                .font(.system(.headline, design: .monospaced))
                .foregroundColor(.black)
                .navigationTitle("Library")
                .font(.system(.headline, design: .monospaced))
                .foregroundColor(.black)
        }
    }
}

#Preview {
    LibraryView()
}
