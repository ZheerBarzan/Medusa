//
//  PrimeryView.swift
//  Medusa
//
//  Created by zheer barzan on 31/1/25.
//

import SwiftUI

struct MainView: View {
    @Environment(AppDataModel.self) var appModel
    
    @State private var showReconstructionView = false
    @State private var showError = false
    
    private var showProgressView: Bool{
        appModel.state == .completed || appModel.state == .ready || appModel.state == .restart
    }
    
    
    var body: some View {
        
        VStack{
            if appModel.state == .capturing{
                if let session = appModel.objectCaptureSession{
                    CaptureMainView(session: session)
                }
            } else if showProgressView {
                CirculerProgressBar()
            }
            
        }.onChange(of: appModel.state){ _,newState in
            if newState == .failed {
                showError = true
                showReconstructionView = false
            } else {
                showError = false
                showReconstructionView = newState == .reconstructing || newState == .viewing
                
            }
        }.sheet(isPresented: $showReconstructionView){
            if let folderManager = appModel.captureFolderManager{
                ReconstructionView(outputFile: folderManager.modelsFolder.appendingPathComponent("model.usdz"))
                    .interactiveDismissDisabled()
            }
        }.alert("Failed: " + (appModel.error != nil ? "\(String(describing: appModel.error!))" : ""),
                isPresented: $showError,
                actions: {
            Button("OK"){
                appModel.state = .restart
            }
            
        },
                message: {
            Text("An error occurred while processing the capture")
        }
        )
    }
}

#Preview {
    MainView()
}
