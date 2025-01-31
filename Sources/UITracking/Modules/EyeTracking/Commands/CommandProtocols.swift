//
//  CommandProtocols.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import Foundation

/// Protocol that defines a handler for Eye Tracker events.
///
/// The `EyeTrackerEventHandler` protocol standardizes how event handlers
/// should be implemented for managing specific Eye Tracking actions.
/// Each event handler is associated with a unique event identifier and contains
/// the logic to execute the event in the context of a given view controller.
protocol EyeTrackerEventHandler {
    
    /// A unique identifier for the event that this handler is responsible for.
    ///
    /// This static property associates a specific event with the handler,
    /// allowing dynamic identification and registration within a `CommandEyeTrackerBus`.
    static var event: String { get }

    /// Executes the logic associated with the event.
    ///
    /// - Parameter controller: The `EyeTrackingViewController` where the event's logic will be executed.
    func execute(on controller: EyeTrackingViewController)
}

