//
//  OnBoardingButtonView.swift
//  Medusa
//
//  Created by zheer barzan on 3/2/25.
//


import SwiftUI
import RealityKit


struct OnBoardingButtonView: View {
    @Environment(AppDataModel.self) var appModel
    var session: ObjectCaptureSession
    var onBoardingFSM: OnBoardingFiniteStateMachine
    @Binding var onBoardingView: Bool
    @Binding var shotLocation: Bool
    
    @State private var userHasIndicatedObjectCannotBeFlipped: Bool? = nil
    @State private var userHasIndicatedFlipObjectAnyway: Bool? = nil
    
    
    var body: some View {
        
        VStack{
            HStack{
                CancelButton(ButtonLabel: "Cancel", onBoardingView: $onBoardingView)
                    .padding(.leading)
                Spacer()
                CameraToggleButton(shotLocation: $shotLocation)
                    .padding([.top , .trailing])
                    .opacity(tutorialPlaying ? 0 : 1)
            }
            Spacer()
            VStack(spacing: 0){
                let currentStateInputs = onBoardingFSM.currentUserInput()
                
                if currentStateInputs.contains(where: { $0 == .continue(isFlippable: false) || $0 == .continue(isFlippable: true) }){
                    CreateButton(buttonLabel: LocalizedString.continue,
                                 buttonLabelColor: .white,
                                 shouldApplyBackground: true,
                                 action: { transition(with: .continue(isFlippable: appModel.isObjectFilppable)) }
                    )
                }
                if currentStateInputs.contains(where: { $0 == .flipObjectAnyway }) {
                    CreateButton(buttonLabel: LocalizedString.flipAnyway,
                                 buttonLabelColor: .black,
                                 action: {
                        userHasIndicatedFlipObjectAnyway = true
                        transition(with: .flipObjectAnyway)
                    })
                }
                if currentStateInputs.contains(where: { $0 == .skip(isFlippable: false) || $0 == .skip(isFlippable: true) }) {
                    CreateButton(buttonLabel: LocalizedString.skip,
                                 buttonLabelColor: .black,
                                 action: {
                        transition(with: .skip(isFlippable: appModel.isObjectFilppable))
                    })
                }
                if currentStateInputs.contains(where: { $0 == .finish }) {
                    let buttonLabel = appModel.captureMode == .scene ? LocalizedString.process : LocalizedString.finish
                    let buttonLabelColor: Color = appModel.captureMode == .scene ? .white :
                    (onBoardingFSM.currentState == .thirdSegmentComplete ? .white : .black)
                    let shouldApplyBackground = appModel.captureMode == .scene ? true : (onBoardingFSM.currentState == .thirdSegmentComplete)
                    let showBusyIndicator = session.state == .finishing && !appModel.isDraftEnabled ? true : false
                    CreateButton(buttonLabel: buttonLabel,
                                 buttonLabelColor: buttonLabelColor,
                                 shouldApplyBackground: shouldApplyBackground,
                                 busyIndicator: showBusyIndicator,
                                 action: { [weak session] in session?.finish() })
                }
                if currentStateInputs.contains(where: { $0 == .objectCannotBeFlipped }) {
                    CreateButton(buttonLabel: LocalizedString.cannotFlipYourObject,
                                 buttonLabelColor: .black,
                                 action: {
                        userHasIndicatedObjectCannotBeFlipped = true
                        transition(with: .objectCannotBeFlipped)
                    })
                }
                if onBoardingFSM.currentState == OnboardingState.tooFewImages ||
                    onBoardingFSM.currentState == .secondSegmentComplete  ||
                    onBoardingFSM.currentState == .thirdSegmentComplete {
                    CreateButton(buttonLabel: "", action: {})
                }
                if currentStateInputs.contains(where: { $0 == .saveDraft }) {
                    let showBusyIndicator = session.state == .finishing && appModel.isDraftEnabled ? true : false
                    CreateButton(buttonLabel: LocalizedString.saveDraft,
                                 buttonLabelColor: .black,
                                 busyIndicator: showBusyIndicator,
                                 action: { [weak appModel] in
                        appModel?.saveDraft()
                    })
                }
            }            .padding(.bottom)
            
        }
    }
    
    
    private var tutorialPlaying: Bool {
        switch onBoardingFSM.currentState {
        case .flipObject, .flipObjectASecondTime, .captureFromLowerAngle, .captureFromHigherAngle:
            return true
        default:
            return false
        }
    }
    
    private func reloadData(){
        switch onBoardingFSM.currentState {
        case .firstSegment, .dismiss:
            onBoardingView = false
        case .secondSegment, .thirdSegment, .additionalOrbitOnCurrentSegment:
            newOrbit()
        default:
            break
        }
        
    }
    
    private func newOrbit(){
        if let userHasIndicatedObjectCannotBeFlipped{
            appModel.objectCannotBeFlipped = userHasIndicatedObjectCannotBeFlipped
        }
        
        if let userHasIndicatedFlipObjectAnyway{
            appModel.objectCanBeFlippedAnyway = userHasIndicatedFlipObjectAnyway
            
        }
        
        if !appModel.isObjectFilppable && !appModel.objectCanBeFlippedAnyway{
            session.beginNewScanPass()
        }else{
            session.beginNewScanPassAfterFlip()
            appModel.isObjectFlipped = true
        }
        
        onBoardingView = false
        appModel.orbit = appModel.orbit.next()
    }
    
    private func transition(with input: OnboardingUserInput){
        do{
            try onBoardingFSM.enter(input)
            reloadData()
        }catch{
            print("could not transition to the requested state")
        }
        
    }
}


private struct CreateButton: View {
    @Environment(AppDataModel.self) var appModel
    let buttonLabel: String
    var buttonLabelColor: Color = .white
    var buttonLabelBackgroundColor: Color = .black
    var shouldApplyBackground: Bool = false
    var busyIndicator: Bool = false
    var action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: {
            action()
            
        },label: {
            ZStack{
                if busyIndicator{
                    HStack{
                        Text(buttonLabel).hidden()
                        Spacer().frame(maxWidth: 48)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: shouldApplyBackground ? .white : (colorScheme == .light ? .black : .white)))
                    }
                }
                Text(buttonLabel)
                    .font(.headline)
                    .bold()
                    .foregroundColor(buttonLabelColor)
                    .padding(16)
                    .frame(maxWidth: shouldApplyBackground ? .infinity : nil)
            }
            
        })
        
        .frame(maxWidth: .infinity)
        .background{
            if shouldApplyBackground{
                RoundedRectangle(cornerRadius: 16).fill( buttonLabelBackgroundColor)
                
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 380 : .infinity)
        
    }
}


private struct CancelButton : View {
    @Environment(AppDataModel.self) var appModel
    let ButtonLabel: String
    @Binding var onBoardingView: Bool
    var body: some View {
        Button(action:{
            onBoardingView = false
        },label: {
            Text(ButtonLabel)
                .font(.headline)
                .bold()
                .foregroundColor(.red)
            
        })
    }
}


private struct CameraToggleButton: View {
    @Binding var shotLocation: Bool
    
    var body: some View {
        VStack(spacing: 0){
            Button(action:{
                shotLocation.toggle()
            }, label: {
                Image(systemName: "camera.viewfinder")
                    .font(.title)
                    .foregroundColor(.black)
                
            })
            .padding(.all, 5)
            .background(.ultraThinMaterial.opacity(shotLocation ? 1 : 0))
            .cornerRadius(15)
            
            
            Text("Show capture positions")
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(width: 80)
        }
    }
}
