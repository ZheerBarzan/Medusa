//
//  CaptureSurfaceView.swift
//  Medusa
//
//  Created by zheer barzan on 5/2/25.
//

import SwiftUI
import RealityKit
import AVFoundation

struct CaptureSurfaceView: View {
    @Environment(AppDataModel.self) var appModel
    var session: ObjectCaptureSession
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CaptureSurfaceView(session: ObjectCaptureSession())
}
