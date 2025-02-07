//
//  SettingsView.swift
//  Medusa
//
//  Created by zheer barzan on 31/1/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppDataModel.self) var appModel
    
    @AppStorage("show_tutorial") var enableTutorial: Bool = true
    @AppStorage("dark_mode") private var isDarkMode: Bool = false



    var body: some View {
        NavigationView{
            VStack{
                
               Toggle("Dark Mode", isOn: $isDarkMode)
                
                Spacer()
                
                Toggle("Show Tutorial", isOn: $enableTutorial)
                    

                
            }
            .navigationTitle("Settings")
                
        }
    }
}

#Preview {
    SettingsView()
}
