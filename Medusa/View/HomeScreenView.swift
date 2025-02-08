//
//  HomeScreenView.swift
//  Medusa
//
//  Created by zheer barzan on 31/1/25.
//

import SwiftUI

struct HomeScreenView: View {
    @Environment(AppDataModel.self) var appModel
    @Environment(\.colorScheme) private var colorScheme
//
//    init() {
//           let tabBarAppearance = UITabBarAppearance()
//           tabBarAppearance.configureWithOpaqueBackground()
//           tabBarAppearance.backgroundColor = UIColor.black // Set the background color to black
//           UITabBar.appearance().standardAppearance = tabBarAppearance
//           UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
//       }
    var body: some View {
        ZStack{
            TabView{
    
                        LibraryView()
                            .tabItem {
                                Image(systemName: "book")
                                Text("Library")
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))

                            }.tag(0)
                        ContentView()
                            .tabItem {
                                Image(systemName: "camera")
                                Text("Camera")
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))

                            }.tag(1)
                        SettingsView()
                            .tabItem {
                                Image(systemName: "gear")
                                Text("Settings")
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))

                            }.tag(2)
                            
                    }.padding(.top, 10)
                    // Set background color
                        .accentColor(colorScheme == .dark ? .white : .black)
                }
        .edgesIgnoringSafeArea(.top)
    }
      
        
        
    
}

#Preview {
    HomeScreenView()
}
