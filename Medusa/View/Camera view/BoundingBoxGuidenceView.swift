//
//  BoundingBoxGuidenceView.swift
//  Medusa
//
//  Created by zheer barzan on 7/2/25.
//

import SwiftUI
import RealityKit

struct BoundingBoxGuidenceView: View {
    @Environment(AppDataModel.self) var appModel
    var session: ObjectCaptureSession
    
    var detectionFailed: Bool
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    
    var body: some View {
        HStack{
            if let guidanceText{
                Text(guidanceText)
                    .font(.callout)
                   
                    .foregroundColor(.white)
                    .transition(.opacity)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: horizontalSizeClass == .regular ? 400 : 300)
                
            }
        }
    }
    
    private var guidanceText: String? {
        
        if case .ready = session.state{
            switch appModel.captureMode{
            case .object:
                if detectionFailed{
                    return NSLocalizedString(
                        "Can‘t find your object. It should be larger than 3 in (8 cm) in each dimension.",
                        bundle: Bundle.main,
                        value: "Can‘t find your object. It should be larger than 3 in (8 cm) in each dimension.",
                        comment: "Feedback message when detection has failed.")
                }else{
                    return NSLocalizedString(
                        "Move close and center the dot on your object, then tap Continue. (Object Capture, State)",
                        bundle: Bundle.main,
                        value: "Move close and center the dot on your object, then tap Continue.",
                        comment: "Feedback message to fill the camera feed with the object.")
                }
            case .scene:
                return NSLocalizedString(
                    "Look at your subject (Object Capture, State).",
                    bundle: Bundle.main,
                    value: "Look at your subject.",
                    comment: "Feedback message to look at the subject in the area mode.")
            }
            
        }else if case .detecting = session.state{
            return NSLocalizedString(
                "Move around to ensure that the whole object is inside the box. Drag handles to manually resize. (Object Capture, State)",
                bundle: Bundle.main,
                value: "Move around to ensure that the whole object is inside the box. Drag handles to manually resize.",
                comment: "Feedback message to resize the box to the object.")
            
        }else {
            return nil
        }
    }
    
}


