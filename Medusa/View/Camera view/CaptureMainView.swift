//
//  CaptureMainView.swift
//  Medusa
//
//  Created by zheer barzan on 4/2/25.
//

import SwiftUI
import RealityKit

struct CaptureMainView: View {
    @Environment(AppDataModel.self) var appModel
    var session: ObjectCaptureSession
    var body: some View {
        ZStack{
            
        }
    }
}

#Preview {
    CaptureMainView(
        session: ObjectCaptureSession()
    )
}
