//
//  FeedbackMessages.swift
//  Medusa
//
//  Created by zheer barzan on 1/2/25.
//
import Foundation
import RealityKit
import SwiftUI


final class FeedbackMessages{
    
    static func getFeedbackMessage(for feedback: ObjectCaptureSession.Feedback, captureMode: AppDataModel.CaptureMode) -> String? {
        switch feedback{
        case .objectTooFar:
            if captureMode == .scene { return nil}
            return NSLocalizedString(
            "Move closer to the object",
            bundle: Bundle.main,
            value: "Move closer to the object",
            comment: "Feedback message to move closer to the object")
            
        case .objectTooClose:
            if captureMode == .scene { return nil}
            return NSLocalizedString(
            "Move away from the object",
            bundle: Bundle.main,
            value: "Move away from the object",
            comment: "Feedback message to move away from the object")
            
        case .environmentTooDark:
            return NSLocalizedString(
            "The environment is too dark",
            bundle: Bundle.main,
            value: "The environment is too dark",
            comment: "Feedback message for too dark environment")
        
        case .environmentLowLight:
            return NSLocalizedString(
            "more light is needed",
            bundle: Bundle.main,
            value: "more light is needed",
            comment: "Feedback message for low light environment")
            
        case .movingTooFast:
            return NSLocalizedString(
            "Move slower",
            bundle: Bundle.main,
            value: "Move slower",
            comment: "Feedback message to move slower")
            
        case .outOfFieldOfView:
            return NSLocalizedString(
            "Object is out of view",
            bundle: Bundle.main,
            value: "Object is out of view",
            comment: "Feedback message for object out of view")
            
        default: return nil
        }
    }
}

