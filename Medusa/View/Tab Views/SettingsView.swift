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
                .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
