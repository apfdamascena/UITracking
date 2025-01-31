//
//  EyeTrackerProtocols.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import Foundation

protocol EyeTrackerDataSource {
    var eyeMovementDelegate: EyeTrackerDelegate? { get set }
}

protocol EyeTrackerSession {
    
    func startSession()
    func endSession()
    
    func isEyeTrackingSupported() -> Bool
}

protocol EyeTrackerPointer {
    func showPointer()
    func hidePointer()
}

protocol EyeTrackerDelegate {
    func sendCoordinates(point: CGPoint)
    func blink(at point: CGPoint)
}

typealias EyeTracker = EyeTrackerDataSource & EyeTrackerSession & EyeTrackerPointer
