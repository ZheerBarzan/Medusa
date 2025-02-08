//
//  FeedbackMessages.swift
//  Medusa
//
//  Created by zheer barzan on 1/2/25.
//
import Foundation
import RealityKit
import SwiftUI

// modify the strings
final class FeedbackMessages{
    
    static func getFeedbackMessage(for feedback: ObjectCaptureSession.Feedback, captureMode: AppDataModel.CaptureMode) -> String? {
        switch feedback{
        case .objectTooFar:
            if captureMode == .scene { return nil}
            return NSLocalizedString(
                "Move Closer (Object Capture)",
                bundle: Bundle.main,
                value: "Move Closer",
                comment: "Feedback message to move closer for object capture")
            
        case .objectTooClose:
            if captureMode == .scene { return nil}
            return NSLocalizedString(
                "Move Farther Away (Object Capture)",
                bundle: Bundle.main,
                value: "Move Farther Away",
                comment: "Feedback message to move back for object capture")
        case .environmentTooDark:
            return NSLocalizedString(
                "More Light Required (Object Capture)",
                bundle: Bundle.main,
                value: "More Light Required",
                comment: "Feedback message that shows the environment is too dark for capturing")
            
        case .environmentLowLight:
            return NSLocalizedString(
                "More Light Recommended (Object Capture)",
                bundle: Bundle.main,
                value: "More Light Recommended",
                comment: "Feedback message to increase lighting for object capture")
            
        case .movingTooFast:
            return NSLocalizedString(
                "Move slower (Object Capture)",
                bundle: Bundle.main,
                value: "Move slower",
                comment: "Feedback message to slow down for object capture")
            
        case .outOfFieldOfView:
            return NSLocalizedString(
                "Aim at your object (Object Capture)",
                bundle: Bundle.main,
                value: "Aim at your object",
                comment: "Feedback message to aim at your object for object capture")
            
        default: return nil
        }
    }
}
