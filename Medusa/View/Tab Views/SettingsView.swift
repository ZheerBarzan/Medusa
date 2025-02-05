//
//  SettingsView.swift
//  Medusa
//
//  Created by zheer barzan on 31/1/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppDataModel.self) var appModel

    var body: some View {
        NavigationView{
            Text("Settings")
                .font(.system(.headline, design: .monospaced))
                .foregroundColor(.black)
                .navigationTitle("Settings")
                .font(.system(.headline, design: .monospaced))
                .foregroundColor(.black)
        }
    }
}

#Preview {
    SettingsView()
}
