//
//  EyeTrackingViewControllerProtocols.swift
//  eye-tracking
//
//  Created by alexdamascena on 16/12/24.
//

import Foundation

/// Protocol that defines the setup for handling navigation events in an Eye Tracking view controller.
///
/// The `EyeTrackingSetupViewController` protocol provides an interface for configuring
/// the necessary logic to navigate back (e.g., pop a view controller) in a view controller
/// that integrates Eye Tracking functionality.
protocol EyeTrackingSetupViewController {
    
    /// Configures the logic to handle the "popViewController" action.
    ///
    /// This method set up the necessary observers
    /// to allow the view controller to respond to user interactions that request
    /// a navigation action to return to the previous screen.
    func setupPopViewController()
}

