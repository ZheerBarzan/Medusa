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
            VStack(alignment: .leading, spacing:20){
                
               Toggle("Dark Mode", isOn: $isDarkMode)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                   
               
                Toggle("Show Tutorial", isOn: $enableTutorial)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                Spacer()
                    

                
            }.padding(20)
            .navigationTitle("Settings")
                
        }
    }
}

#Preview {
    SettingsView()
}
