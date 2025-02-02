//
//  EyeTrackingAdapter.swift
//  eye-tracking
//
//  Created by alexdamascena on 22/11/24.
//

import Foundation
import UIKit


public class EyeTrackingAdapter: EyeTrackerDelegate {

    var delegate: EyeTracingInterpreterDelegate?
    let interpreter: EyeTracingInterpreter
    
    init(tracker: EyeTracker,
         interpreter: EyeTracingInterpreter){
    
        self.interpreter = interpreter
        
        var tracking = tracker
        tracking.eyeMovementDelegate = self
    }
    
    public func sendCoordinates(point: CGPoint) {
        let hasAction = interpreter.interpretEyeAction(with: point)
        let section = interpreter.interpretEyeMovement(with: point)
        
        guard let action = hasAction else {
            delegate?.onEyeMovement(section)
            return
        }
        
        delegate?.onEyeAction(action, section)
    }
    
    public func blink(at point: CGPoint) {
        let section = interpreter.interpretEyeMovement(with: point)
        delegate?.onEyeAction(.select, section)
    }
}
