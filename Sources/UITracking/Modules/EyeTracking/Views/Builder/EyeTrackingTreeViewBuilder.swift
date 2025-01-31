//
//  EyeTrackingTreeViewBuilder.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import Foundation

/// A builder responsible for constructing the view of `EyeTrackingView`, representing the hierarchical division of the screen.
///
/// The view created by this class divides the screen into sections and subsections, allowing for organizing the user's interaction areas
/// in the context of eye-tracking. Each node in the tree represents a visual area, and it is possible to configure events and behavior
/// for these areas.
@MainActor
open class EyeTrackingTreeViewBuilder {
    
    /// The root of the tree, representing the main view of the screen.
    ///
    /// All subsections and divisions of the screen will be organized starting from this node.
    private var root: EyeTrackingView
    
    /// Initializes a new instance of the builder with an empty `EyeTrackingView` as the root.
    public init() {
        self.root = EyeTrackingView()
    }
    
    /// Adds a new section to view. Divide the entire screen on the number of sections..
    ///
    /// Each section can contain subsections and is used to logically divide the screen into smaller parts.
    /// This method allows the creation of a section hierarchy, organizing screen areas for eye-tracking.
    ///
    /// - Parameter builder: A closure that configures the subsections of the new section. It receives an `EyeTrackingTreeViewBuilder`
    ///                      that allows for recursive configuration of subsections.
    /// - Returns: The current instance of `EyeTrackingTreeViewBuilder` to allow method chaining.
    func addSection(builder: (EyeTrackingTreeViewBuilder) -> EyeTrackingTreeViewBuilder) -> EyeTrackingTreeViewBuilder {
        let childBuilder = EyeTrackingTreeViewBuilder()
        let childView = builder(childBuilder).build()
        root.subTrackingViews.append(childView)
        return self
    }
    
    /// Adds a new `EyeTrackingView` to the view, without associating a specific event.
    ///
    /// This method is used to add visual interaction areas that do not require an associated event.
    ///
    /// - Parameters:
    ///   - view: The `EyeTrackingView` to be added as a child node.
    ///   - onConfiguration: An optional closure to configure the view before adding it to the tree.
    /// - Returns: The current instance of `EyeTrackingTreeViewBuilder`.
    func addView(_ view: EyeTrackingView, onConfiguration: ((EyeTrackingView) -> Void)? = nil) -> EyeTrackingTreeViewBuilder {
        onConfiguration?(view)
        root.subTrackingViews.append(view)
        return self
    }
    
    /// Adds a new `EyeTrackingView` to the view, associating it with a specific event.
    ///
    /// This method is used for visual interaction areas that should trigger an event when activated by eye-tracking.
    ///
    /// - Parameters:
    ///   - view: The `EyeTrackingView` to be added as a child node.
    ///   - event: A string representing the identifier of the event associated with the view.
    ///   - onConfiguration: An optional closure to configure the view before adding it to the tree.
    /// - Returns: The current instance of `EyeTrackingTreeViewBuilder`.
    func addViewWithEvent(_ view: EyeTrackingView, event: String, onConfiguration: ((EyeTrackingView) -> Void)? = nil) -> EyeTrackingTreeViewBuilder {
        onConfiguration?(view)
        view.event = event
        root.subTrackingViews.append(view)
        return self
    }
    
    /// Finalizes the tree construction and returns the root view.
    ///
    /// - Returns: The root of the `EyeTrackingView` tree, representing the complete screen division structure.
    func build() -> EyeTrackingView {
        return root
    }
}

