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
        if let imageURL = getFirstPicture(from: captureFolderURL){
            ShareLink(item: captureFolderURL){
                VStack(spacing: 8){
                    VStack{
                        if let image {
                            Image(decorative: image, scale: 1.0)
                                .resizable()
                                .scaledToFill()
                        }else{
                            ProgressView()
                        }
                    }.frame(width: frameSize.width, height: frameSize.height)
                        .clipped()
                        .cornerRadius(10)
                    
                    let folderName = captureFolderURL.lastPathComponent
                    Text("\(folderName)")
                        .foregroundColor(.primary)
                        .font(.caption2)
                    Spacer()
                }
                .frame(width: frameSize.width, height: frameSize.height)
                .task{
                    image = await createThumbnail(url: imageURL)
                }
            }
        }
    }
    
    private nonisolated func createThumbnail(url: URL) async -> CGImage? {
        let Options = [
            kCGImageSourceThumbnailMaxPixelSize: frameSize.width * 2,
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true] as CFDictionary
        
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil),
              let thumbnail = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, Options) else {
            return nil
        }
        
        return thumbnail
    }
        
    private func getFirstPicture(from url: URL)  -> URL? {
        let imageFolderURL = url.appendingPathComponent(CaptureFolderManager.imageFolderName)
        let imageURL: URL? = try? FileManager.default.contentsOfDirectory(
            at: imageFolderURL,
            includingPropertiesForKeys: nil,
            options: [])
            .filter{ !$0.hasDirectoryPath }
            .sorted(by: { $0.path < $1.path }).first
        return imageURL
    }
}

