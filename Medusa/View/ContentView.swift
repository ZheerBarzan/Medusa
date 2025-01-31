//
//  ContentView.swift
//  Medusa
//
//  Created by zheer barzan on 30/1/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppDataModel.self) var appModel
    var body: some View {
       PrimeryView()
            .onAppear(perform:{
                UIApplication.shared.isIdleTimerDisabled = true
            })
            .onDisappear(perform:{
                UIApplication.shared.isIdleTimerDisabled = false
            })
    }
}

#Preview {
    ContentView()
}
