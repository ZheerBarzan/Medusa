//
//  ModelView.swift
//  Medusa
//
//  Created by zheer barzan on 5/2/25.
//

import SwiftUI

struct ModelView: View {
    let modelFile: URL
    let captureFinishedCallback: () -> Void
    var body: some View {
        ARQuickLookController(modelFile: modelFile, captureFinishedCallback: captureFinishedCallback)
    }
}


