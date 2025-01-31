//
//  MedusaApp.swift
//  Medusa
//
//  Created by zheer barzan on 30/1/25.
//

import SwiftUI

@main
struct MedusaApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchScreen()
                .environment(AppDataModel.instance)
                .preferredColorScheme(.light)
        }
    }
}
