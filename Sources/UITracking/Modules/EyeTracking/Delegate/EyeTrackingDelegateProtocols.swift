//
//  EyeTrackingDelegateProtocols.swift
//  eye-tracking
//
//  Created by alexdamascena on 16/12/24.
//

import Foundation
import RxSwift

/// Protocol that defines the interaction for triggering pop navigation events in Eye Tracking.
///
/// The `EyeTrackingDelegate` protocol provides an interface to manage user-triggered events
/// for navigating back in the application.
public protocol EyeTrackingDelegate {

    /// A reactive subject that emits events when the user requests to navigate back.
    ///
    /// This `PublishSubject` can be observed by other parts of the system to handle
    /// the `popViewController` action in the associated view controller.
    var popActionSubject: PublishSubject<Void> { get }

    /// Triggers the navigation event for going back to the previous screen.
    ///
    /// This method should be called when the user interacts with the system
    /// (e.g., through an Eye Tracking gesture) to request a "go back" action.
    func userTappedGoBack()
}

