//
//  EyeTrackerProtocols.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import Foundation

public protocol EyeTrackerDataSource {
    var eyeMovementDelegate: EyeTrackerDelegate? { get set }
}

public protocol EyeTrackerSession {
    
    func startSession()
    func endSession()
    
    func isEyeTrackingSupported() -> Bool
}

public protocol EyeTrackerPointer {
    func showPointer()
    func hidePointer()
}

public protocol EyeTrackerDelegate {
    func sendCoordinates(point: CGPoint)
    func blink(at point: CGPoint)
}

public typealias EyeTracker = EyeTrackerDataSource & EyeTrackerSession & EyeTrackerPointer
