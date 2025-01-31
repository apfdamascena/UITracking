//
//  EyeTrackingView.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import UIKit

/// A view that represents a section of the screen used in an eye-tracking application.
/// It is a container that can hold other `EyeTrackingView` instances, creating a hierarchical structure of views.
///
/// The view can be used for organizing interactive areas of the screen that will be monitored by eye-tracking.
/// Each instance can represent a part of the screen or a subarea, with the ability to add constraints and subviews to represent different sections visually.
@MainActor
public class EyeTrackingView: UIView, @preconcurrency AnyEyeTrackingView, @preconcurrency AnyEyeTrackingAction {
    
    /// A string that represents the event associated with this view, if any.
    ///
    /// This event is used in the context of eye-tracking to trigger specific actions when the user interacts with the area.
    var event: String?
    
    /// A list of child `EyeTrackingView` objects, representing sub-areas within this view.
    ///
    /// These child views form a hierarchical structure, enabling a complex layout for organizing eye-tracking zones on the screen.
    var subTrackingViews: [EyeTrackingView] = []
    
    /// Initializes a new `EyeTrackingView` instance with an optional list of sub-views.
    ///
    /// - Parameter subTrackingViews: An optional array of child `EyeTrackingView` objects to be added to the view.
    init(subTrackingViews: [EyeTrackingView] = []) {
        self.subTrackingViews = subTrackingViews
        super.init(frame: .zero)
        setupView()
    }
    
    /// Initializes a new `EyeTrackingView` instance with an optional list of sub-views and an event.
    ///
    /// - Parameters:
    ///   - subTrackingViews: An optional array of child `EyeTrackingView` objects to be added to the view.
    ///   - event: A string that represents the event associated with this view.
    init(subTrackingViews: [EyeTrackingView] = [], event: String) {
        self.subTrackingViews = subTrackingViews
        self.event = event
        super.init(frame: .zero)
        setupView()
    }
    
    /// Required initializer for using the view from a storyboard or nib.
    /// It raises a runtime error if called directly, as this view is intended to be instantiated programmatically.
    ///
    /// - Parameter coder: The coder used to initialize the view.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Adds subviews to the current view.
    ///
    /// This method sets the background color of the view to white.
    func addSubviews() {
        self.backgroundColor = .white
    }
    
    /// Recursively adds child subviews to the current view.
    ///
    /// This method iterates over the `subTrackingViews` array and adds each child view to the parent view.
    func addChildrenSubviews() {
        subTrackingViews.forEach { view in
            self.addSubview(view)
            view.addChildrenSubviews()
        }
    }
    
    /// Sets up constraints for the child subviews of the current view.
    ///
    /// This method ensures that the child views are laid out correctly by setting constraints. It handles
    /// positioning the child views vertically, ensuring they are distributed evenly within the parent view.
    /// If there are no child views, a default multiplier of 1 is applied to the height.
    func addChildrenContraintsSubViews() {
        let viewsCount = subTrackingViews.count == 0 ? 1 : subTrackingViews.count
        let multiplier: Double = Double(1) / Double(viewsCount)

        subTrackingViews.enumerated().forEach { (index, view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if index > 0 {
                let previousView = subTrackingViews[index-1]
                view.topAnchor.constraint(equalTo: previousView.bottomAnchor).isActive = true
            } else {
                view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            }
            
            view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: multiplier).isActive = true
        }
        
        subTrackingViews.forEach { view in
            view.addChildrenContraintsSubViews()
        }
    }
    
    /// Draws a border around the view.
    ///
    /// This method sets the layer's border width to 2 and applies a green color for the border.
    /// This is typically used for visual debugging or highlighting the area in the UI.
    func drawBorder() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.green.cgColor
    }
}

