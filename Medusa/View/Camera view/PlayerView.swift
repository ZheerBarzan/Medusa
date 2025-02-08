//
//  PlayerView.swift
//  Medusa
//
//  Created by zheer barzan on 5/2/25.
//

import SwiftUI
import AVKit

struct PlayerView: UIViewRepresentable {
    
    
    let url: URL
    let isInverted: Bool
    
    private static let transparentPixelBufferAttributes = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    func makeUIView(context: Context) -> AVPlayerView {
        
        let playerView = AVPlayerView()
        let playerItem = AVPlayerItem(url: url)
        
        applyVideoComposition(to: playerItem)
        
        let player = AVQueuePlayer(playerItem: playerItem)
        
        player.actionAtItemEnd = .pause
        playerView.player = player
        
        if let playerLayer = playerView.playerLayer{
            playerLayer.videoGravity = .resizeAspect
            playerLayer.pixelBufferAttributes = Self.transparentPixelBufferAttributes
        }
        
        return playerView
    }
    
    func updateUIView(_ playerView: AVPlayerView, context: Context) {
        
        let currentItemURL: URL? = (playerView.player?.currentItem?.asset as? AVURLAsset)?.url
        if currentItemURL != url{
            let playerItem = AVPlayerItem(url: url)
            applyVideoComposition(to: playerItem)
            
            playerView.player?.replaceCurrentItem(with: playerItem)
        }
        playerView.player?.play()
    }
    
    
    
    private func applyVideoComposition(to playerItem: AVPlayerItem){
        AVMutableVideoComposition.videoComposition(with: playerItem.asset, applyingCIFiltersWithHandler: { request in
            guard let filter = CIFilter(name: "CIMaskToAlpha") else { return }
            
            filter.setValue(request.sourceImage, forKey: kCIInputImageKey)
            
            guard let outputImage = filter.outputImage else { return }
            
            if isInverted{
                let invertedFilter = outputImage.applyingFilter("CIColorInvert")
                return request.finish(with: invertedFilter, context: nil)
                
            }
            request.finish(with: outputImage, context: nil)
            
        }, completionHandler: { compostion, error in
            playerItem.asset.loadTracks(withMediaType: .video) { tracks, error in
                Task{ @MainActor in 
                    if let tracks{
                        var videoSize: CGSize?
                        
                        for track in tracks{
                            let naturalSize = try await track.load(.naturalSize)
                            let preferredTransform = try await track.load(.preferredTransform)
                            
                            videoSize = !tracks.isEmpty ? naturalSize.applying(preferredTransform) : nil
                        }
                        
                        if let compostion,
                           let videoSize {
                            compostion.renderSize = videoSize
                            playerItem.videoComposition = compostion
                        }
                    }
                }
                
            }
        })
    }
}


class Coordinator {
    var PlayerLoop: AVPlayerLooper?
    
}


class AVPlayerView: UIView{
    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer? {
        layer as? AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get { playerLayer?.player }
        set { playerLayer?.player = newValue }
    }
}
