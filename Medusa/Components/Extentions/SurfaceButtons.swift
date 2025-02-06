//
//  SurfaceButtons.swift
//  Medusa
//
//  Created by zheer barzan on 6/2/25.
//

import Foundation
import RealityKit
import SwiftUI

protocol SurfaceButtons{
    func CaptureStarted(state: ObjectCaptureSession.CaptureState) -> Bool
}


extension SurfaceButtons{
    func CaptureStarted(state: ObjectCaptureSession.CaptureState) -> Bool{
        switch state{
        case .initializing, .ready , .detecting:
            return false
        default:
            return true
        }
    }
}
