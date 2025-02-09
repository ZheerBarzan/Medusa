//
//  ReconstructionView.swift
//  Medusa
//
//  Created by zheer barzan on 4/2/25.
//

import SwiftUI
import RealityKit


struct ReconstructionView: View {
    @Environment(AppDataModel.self) var appModel
    let outputFile: URL
    
    @State private var completed: Bool = false
    @State private var cancelled: Bool = false
    
    var body: some View {
        if completed && !cancelled{
            ModelView(modelFile: outputFile, captureFinishedCallback: { [weak appModel] in
                appModel?.endCapture()
                
            })
            .onAppear(perform: {
                UIApplication.shared.isIdleTimerDisabled = false
            })
        }else{
            ReconstructionProgressView(outputFile: outputFile, completed: $completed, cancelled: $cancelled)
                
        }
    }
}


struct ReconstructionProgressView: View {
    @Environment(AppDataModel.self) var appModel
    let outputFile: URL
    @Binding var completed: Bool
    @Binding var cancelled: Bool
    
    @State private var progress: Float = 0.0
    @State private var timeRemaining: TimeInterval?
    @State private var processingStageDescription: String?
    @State private var pointCloud: PhotogrammetrySession.PointCloud?
    @State private var gotError: Bool = false
    @State private var error: Error?
    @State private var isCanceling: Bool = false
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    private var padding: CGFloat {
        horizontalSizeClass == .regular ? 60 : 24
    }
    
    private func isReconstructing() -> Bool {
        return !completed && !cancelled && !gotError
    }
    var body: some View {
        VStack(spacing: 0){
            if isReconstructing(){
                HStack{
                    Button(action: {
                        isCanceling = true
                        appModel.photogrammetrySession?.cancel()
                        
                    }, label: {
                        Text(LocalizedString.cancel)
                            .font(.system(.headline, design: .monospaced))
                            .bold()
                            .padding(30)
                            .foregroundColor(.black)
                        
                    })
                    .padding(.trailing)
                    Spacer()
                }
            }
            Spacer()
            
            TitleView()
            Spacer()
            
            ProgressBarView(progress: progress, timeRemaining: timeRemaining, processStage: processingStageDescription)
                .padding(padding)
            
            Spacer()
            Spacer()
            Spacer()
            
        }.frame(maxWidth: .infinity)
            .padding(.bottom, 20)
            .alert(
                "Failed:  " + (error != nil  ? "\(String(describing: error!))" : ""),
                isPresented: $gotError,
                actions: {
                    Button("OK"){
                        appModel.state = .restart
                    }
                },
                message: {}
            )
            .task {
                precondition(appModel.state == .reconstructing)
                assert(appModel.photogrammetrySession != nil)
                
                guard let session = appModel.photogrammetrySession else { return }
                
                let outputs = UntilProcessingCompleteFilter(input: session.outputs)
                
                do{
                    try session.process(requests: [.modelFile(url: outputFile)])
                    
                }catch{
                }
                
                for await output in outputs{
                    switch output {
                    case .inputComplete:
                        break
                    case .requestProgress(let request, fractionComplete: let fractionComplete):
                        if case .modelFile = request{
                            progress = Float(fractionComplete)
                        }
                    case .requestProgressInfo(let request, let progressInfo):
                        if case .modelFile = request{
                            timeRemaining = progressInfo.estimatedRemainingTime
                            processingStageDescription = progressInfo.processingStage?.processingStageString
                        }
                    case .requestComplete(let request, _):
                        switch request{
                        case .modelFile(_,_,_):
                            print("Model file request complete")
                        case .modelEntity(_, _), .bounds, .poses, .pointCloud:
                            // Not supported yet
                            break
                        @unknown default:
                            print("\(String(describing: request))")
                        }
                    case .requestError(_, let requestError):
                        if !isCanceling{
                            gotError = true
                            error = requestError
                        }
                    case .processingComplete:
                        if !gotError{
                            completed = true
                            appModel.state = .viewing
                        }
                    case .processingCancelled:
                        cancelled = true
                        appModel.state = .restart
                    case .invalidSample(id: _, reason: _), .skippedSample(id: _), .automaticDownsampling:
                        continue
                    case .stitchingIncomplete:
                        print("Stitching incomplete")
                        
                    @unknown default:
                        print("\(String(describing: output))")
                    }
                }
                print("Reconstruction task exited")
            }
        }
        struct LocalizedString {
            static let cancel = NSLocalizedString(
                "Cancel (Object Reconstruction)",
                bundle: Bundle.main,
                value: "Cancel",
                comment: "Button title to cancel reconstruction.")
        }
    }
    
    
    extension PhotogrammetrySession.Output.ProcessingStage {
        var processingStageString: String? {
            switch self {
            case .preProcessing:
                return NSLocalizedString(
                    "Preprocessing (Reconstruction)",
                    bundle: Bundle.main,
                    value: "Preprocessing…",
                    comment: "Feedback message during the object reconstruction phase."
                )
            case .imageAlignment:
                return NSLocalizedString(
                    "Aligning Images (Reconstruction)",
                    bundle: Bundle.main,
                    value: "Aligning Images…",
                    comment: "Feedback message during the object reconstruction phase."
                )
            case .pointCloudGeneration:
                return NSLocalizedString(
                    "Generating Point Cloud (Reconstruction)",
                    bundle: Bundle.main,
                    value: "Generating Point Cloud…",
                    comment: "Feedback message during the object reconstruction phase."
                )
            case .meshGeneration:
                return NSLocalizedString(
                    "Generating Mesh (Reconstruction)",
                    bundle: Bundle.main,
                    value: "Generating Mesh…",
                    comment: "Feedback message during the object reconstruction phase."
                )
            case .textureMapping:
                return NSLocalizedString(
                    "Mapping Texture (Reconstruction)",
                    bundle: Bundle.main,
                    value: "Mapping Texture…",
                    comment: "Feedback message during the object reconstruction phase."
                )
            case .optimization:
                return NSLocalizedString(
                    "Optimizing (Reconstruction)",
                    bundle: Bundle.main,
                    value: "Optimizing…",
                    comment: "Feedback message during the object reconstruction phase."
                )
            default:
                return nil
            }
        }
    }
    
    
    private struct TitleView: View {
        var body: some View {
            Text(LocalizedString.processingTitle)
                .font(.title)
                .fontWeight(.bold)
        }
        
        private struct LocalizedString {
            static let processingTitle = NSLocalizedString(
                "Processing title (Object Capture)",
                bundle: Bundle.main,
                value: "Processing",
                comment: "Title of processing view during processing phase."
            )
        }
    }
