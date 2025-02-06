//
//  ThumbnailView.swift
//  Medusa
//
//  Created by zheer barzan on 6/2/25.
//

import SwiftUI

struct ThumbnailView: View {
    let captureFolderURL: URL
    let frameSize: CGSize
    @State private var image: CGImage?
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    private nonisolated func createThumbnail(url: URL) async -> CGImage? {
        
        return nil
    }
        
    private func getFirstPicture(from url: URL) async -> URL? {
        
        return nil
    }
}

