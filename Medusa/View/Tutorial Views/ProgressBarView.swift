//
//  ProgressBarView.swift
//  Medusa
//
//  Created by zheer barzan on 5/2/25.
//

import SwiftUI
import RealityKit


struct ProgressBarView: View {
    @Environment(AppDataModel.self) var appModel
    
    // The progress value from 0 to 1 that describes the amount of coverage completed.
    var progress: Float
    var timeRemaining: TimeInterval?
    var processStage: String?
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    private var formattedTimeRemaining: String? {
        guard let timeRemaining else { return nil }
        
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second]
        return formatter.string(from: timeRemaining)
    }
    
    private var numberOfImages: Int{
        guard let folderManager = appModel.captureFolderManager else { return 0 }
        guard let urls = try? FileManager.default.contentsOfDirectory(
            at: folderManager.imagesFolder,
            includingPropertiesForKeys: nil) else{
            return 0
        }
        return urls.filter { $0.pathExtension.uppercased() == "HEIC" }.count
    }
    
    
    var body: some View {
        VStack(spacing: 22){
            VStack(spacing: 12){
                HStack(spacing: 0){
                    Text(processStage ?? LocalizedString.processing)
                        .font(.system(.headline, design: .monospaced))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(progress, format: .percent.precision(.fractionLength(0)))
                        .bold()
                        .monospacedDigit()
                }
                .font(.body)
                
                ProgressView(value: progress)
            }
            HStack(alignment: .center, spacing: 0){
                VStack(alignment: .center){
                    Image(systemName: "photo")
                        .resizable()
                    
                    Text(String(numberOfImages))
                        .frame(alignment: .bottom)
                        .hidden()
                        .overlay{
                            Text(String(numberOfImages))
                                .font(.system(.subheadline, design: .monospaced))
                                .foregroundColor(.black)
                        }
                }
                .font(.subheadline)
                .padding(.trailing,16)
                
                VStack(alignment: .leading){
                    Text(LocalizedString.processingModel)
                    
                    Text(String.localizedStringWithFormat(LocalizedString.timeRemaining, formattedTimeRemaining ?? LocalizedString.calcualting))
                }
                font(.system(.subheadline, design: .monospaced))
            }
            .foregroundColor(.secondary)
        }
    }
    
    
    private struct LocalizedString{
        static let processing = NSLocalizedString(
            "Processing (Object Capture)",
            bundle: Bundle.main,
            value: "Processing...",
            comment: "The process is in progress"
        )
        
        static let processingModel = NSLocalizedString(
            "Keep the app Running while Processing the model. (Object Capture)",
            bundle: Bundle.main,
            value: "Keep the app Running while Processing the model",
            comment: "The process is in progress"
        )
        
        static let timeRemaining = NSLocalizedString(
            "Time Remaining:  %@ (Object Capture)",
            bundle: Bundle.main,
            value: "Time Remaining:  %@",
            comment: "The time remaining to Finish the process"
        )
        
        static let calcualting = NSLocalizedString(
            "Calculating… (Estimated time, Object Capture)",
            bundle: Bundle.main,
            value: "Calculating…",
            comment: "estimatied time is not available yet"
        )
    }
}
