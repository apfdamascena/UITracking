//
//  EyeViewProtocols.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import Foundation

/// A protocol that defines the structure and behavior for any view used in the eye-tracking system.
///
/// The `AnyEyeTrackingView` protocol provides methods to manage the hierarchical structure of subviews, including adding and constraining them,
/// as well as methods to configure and visually update the view.
protocol AnyEyeTrackingView {
    
    /// Adds subviews to the current view.
    ///
    /// This method is intended to be overridden to define how subviews are added.
    func addSubviews()
    
    /// Adds constraints to the subviews of the current view.
    ///
    /// This method is intended to be overridden to define layout constraints for the added subviews.
    func addConstraintsSubviews()
    
    /// Adds child views to the subviews of the current view.
    ///
    /// This is useful for adding nested views or composite components.
    func addChildrenSubviews()
    
    /// Adds constraints to the child views of the subviews.
    ///
    /// This ensures that all nested child views are properly constrained within their parent views.
    func addChildrenContraintsSubViews()
    
    /// Sets up the view by adding and constraining all subviews and child subviews.
    ///
    /// This method provides a default implementation that calls the appropriate methods in sequence:
    /// - `addSubviews()`
    /// - `addChildrenSubviews()`
    /// - `addConstraintsSubviews()`
    /// - `addChildrenContraintsSubViews()`
    func setupView()
    
    /// Draws a border around the view.
    ///
    /// This method should be overridden to provide visual updates to the view, such as highlighting or debugging borders.
    func drawBorder()
}

/// Default implementation of the `AnyEyeTrackingView` protocol.
///
/// This extension provides default (empty) implementations for all methods, except for `setupView()`, which
/// calls the other methods in the proper sequence.
extension AnyEyeTrackingView {
    
    func addSubviews() {
        // Default implementation: No operation.
    }
    
    func addConstraintsSubviews() {
        // Default implementation: No operation.
    }
    
    func addChildrenSubviews() {
        // Default implementation: No operation.
    }
    
    func addChildrenContraintsSubViews() {
        // Default implementation: No operation.
    }
    
    func setupView() {
        addSubviews()
        addChildrenSubviews()
        addConstraintsSubviews()
        addChildrenContraintsSubViews()
    }
}

/// A protocol that defines actions for views used in the eye-tracking system.
///
/// The `AnyEyeTrackingAction` protocol provides a structure for associating actions with events within a view.
protocol AnyEyeTrackingAction {
    
    /// The event identifier associated with the action.
    ///
    /// This property links a specific action to an event name, allowing it to be triggered in response to user interactions or eye-tracking data.
    var event: String? { get set }
}

