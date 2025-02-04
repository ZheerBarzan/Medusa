//
//  ReconstructionView.swift
//  Medusa
//
//  Created by zheer barzan on 4/2/25.
//

import SwiftUI

struct ReconstructionView: View {
    @Environment(AppDataModel.self) var appModel
       let outputFile: URL
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ReconstructionView(
        outputFile: URL(fileURLWithPath: "")
    )
}
