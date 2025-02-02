//
//  EyeTracingProtocol.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import Foundation

/// Protocol responsible for interpreting eye-tracking data and translating it into actions or movements.
///
/// The `EyeTracingInterpreter` protocol defines the methods that must be implemented by any interpreter responsible for
/// processing eye movements and translating them into actionable data within the eye-tracking system.
public protocol EyeTracingInterpreter {
    
    /// Interprets the eye movement based on the given point in the coordinate system.
    ///
    /// - Parameter point: The CGPoint representing the coordinates of the eye movement in the view.
    /// - Returns: An integer value that corresponds to the section or area affected by the eye movement.
    func interpretEyeMovement(with point: CGPoint) -> Int
    
    /// Interprets the eye action based on the given point in the coordinate system.
    ///
    /// This could involve identifying whether the action is a select, deselect, or pop event based on eye movement.
    ///
    /// - Parameter point: The CGPoint representing the coordinates of the eye action in the view.
    /// - Returns: An optional `EyeAction` that represents the action detected, or `nil` if no action is detected.
    func interpretEyeAction(with point: CGPoint) -> EyeAction?
    
    /// Sets the quantity of sections in the view that the eye-tracking system is monitoring.
    ///
    /// This is typically used to dynamically update the number of sections as the view hierarchy changes.
    ///
    /// - Parameter quantity: The total number of sections to be considered in the view hierarchy.
    func setSectionViewQuantity(_ quantity: Int)
}

/// Delegate protocol for handling eye-tracking events.
///
/// The `EyeTracingInterpreterDelegate` protocol is used by the interpreter to notify its delegate about eye actions
/// and movements within the system. This allows for the handling of these events in a responsive manner.
protocol EyeTracingInterpreterDelegate {
    
    /// Called when an eye action is detected.
    ///
    /// - Parameters:
    ///   - action: The type of `EyeAction` that was triggered by the user's eye movement.
    ///   - section: The section or area in the view where the action was performed.
    func onEyeAction(_ action: EyeAction, _ section: Int)
    
    /// Called when an eye movement is detected.
    ///
    /// - Parameter section: The section or area in the view where the eye movement was detected.
    func onEyeMovement(_ section: Int)
}

