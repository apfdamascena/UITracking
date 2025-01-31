//
//  CommandBusProtocols.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import Foundation

/// Protocol that defines a Command Bus for managing Eye Tracker events.
///
/// The `CommandEyeTrackerBus` protocol provides an interface to register, delete,
/// and execute events related to Eye Tracking. It acts as a mediator between
/// the Eye Tracker events and their corresponding handlers.
protocol CommandEyeTrackerBus {
    
    /// A dictionary that maps event identifiers to their respective handlers.
    ///
    /// Each event is associated with a `String` key and an `EyeTrackerEventHandler` value,
    /// allowing the dynamic management of event handling logic.
    var events: [String: EyeTrackerEventHandler] { get }

    /// Registers a new event with a specified handler.
    ///
    /// - Parameters:
    ///   - event: The identifier of the event to be registered.
    ///   - handler: The handler that will execute the logic for the specified event.
    func registerEvent(_ event: String, handler: EyeTrackerEventHandler)

    /// Deletes a previously registered event.
    ///
    /// - Parameter event: The identifier of the event to be removed from the bus.
    func deleteEvent(_ event: String)

    /// Executes a registered event using a specified view controller.
    ///
    /// - Parameters:
    ///   - event: The identifier of the event to be executed.
    ///   - controller: The `EyeTrackingViewController` responsible for the execution context.
    func executeEvent(_ event: String, controller: EyeTrackingViewController)
}

