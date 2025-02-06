//
//  ARQuickLookController.swift
//  Medusa
//
//  Created by zheer barzan on 5/2/25.
//

import SwiftUI
import QuickLook

struct ARQuickLookController: UIViewControllerRepresentable {
    
    
    let modelFile: URL
    let captureFinishedCallback: () -> Void
    
    func makeUIViewController(context: Context) -> QuickLookPreviewControllerWrapper{
        let controller = QuickLookPreviewControllerWrapper()
        controller.quickLookViewControler.dataSource = context.coordinator
        controller.quickLookViewControler.delegate = context.coordinator
        
        return controller
        
    }
    
    func makeCoordinator() -> ARQuickLookController.Coordinator {
        return Coordinator(parent: self)
    }
        
    func updateUIViewController(_ uiViewController: QuickLookPreviewControllerWrapper, context: Context) {}
    
    class Coordinator: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
        let parent: ARQuickLookController
        
        init(parent inParent: ARQuickLookController){
            parent = inParent
        }
        
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.modelFile as QLPreviewItem
        }
        
        func previewControllerWillDismiss(_ controller: QLPreviewController) {
            parent.captureFinishedCallback()
        }
    }
}


