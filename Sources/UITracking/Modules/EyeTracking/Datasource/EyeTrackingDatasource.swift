//
//  EyeTrackingDatasource.swift
//  eye-tracking
//
//  Created by alexdamascena on 16/12/24.
//

import Foundation

/// Protocol that defines the data source for managing Eye Tracking functionality.
///
/// The `EyeTrackingDatasource` protocol centralizes the components required to handle
/// eye-tracking operations, including the detection of eye movements, translation of raw data
/// into user context, and managing associated events and view depth states.
protocol EyeTrackingDatasource {
    
    /// The core Eye Tracking system responsible for detecting eye movements.
    ///
    /// This property represents the primary component that captures and tracks
    /// the user's eye movements in real-time.
    var tracking: EyeTracker { get }
    
    /// Adapter responsible for converting raw eye tracking data into meaningful user actions.
    ///
    /// The `trackerAdapter` processes the data provided by `tracking`, such as X and Y coordinates,
    /// and interprets it to determine actions like blinking or eye movement direction.
    var trackerAdapter: EyeTrackingAdapter { get }
    
    /// Command Bus that manages events and their respective handlers.
    ///
    /// The `commandBus` acts as a registry for all events and event handlers,
    /// ensuring the correct actions are executed when a registered event is triggered in a view.
    var commandBus: CommandEyeTrackerBus { get }
    
    /// Interpreter that translates eye tracking data into actionable context.
    ///
    /// This component, embedded within the `trackerAdapter`, recalculates view sections
    /// and provides insights into the user's current eye behavior.
    /// It is accessed separately due to its role in recalculating interactions dynamically.
    var interpreter: EyeTracingInterpreter { get }
    
    /// Tracks the depth of views selected so far.
    ///
    /// The `depths` array represents the levels of nested views that have been selected by the user,
    /// enabling context-sensitive interactions based on the current navigation state.
    var depths: [Int] { get set }
}

