//
//  EyeMovePresentable.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import Foundation

/// A protocol that defines the presenter layer for handling communication between the Eye Tracking logic and the view.
///
/// The `EyeMovePresentable` protocol manages the presentation logic required for updating the user interface based on
/// the current state of eye-tracking interactions. It provides methods for drawing focus areas, handling view navigation,
/// and calculating sections within a hierarchical view structure.
protocol EyeMovePresentable {
    
    /// The view associated with the presenter, responsible for rendering the focus area and receiving updates.
    var view: EyeMoveView? { get set }
    
    /// Draws a focus area on the view for a specific section and memoized depth.
    ///
    /// This method updates the view to highlight the focus area corresponding to the user's current eye-tracking position.
    ///
    /// - Parameters:
    ///   - section: The index of the section being focused on.
    ///   - memoDepth: An array representing the hierarchical depth of selected views.
    func drawFocusArea(for section: Int, on memoDepth: [Int])
    
    /// Loads the event associated with the specified section and memoized depth.
    ///
    /// This method retrieves the event identifier for the current context, which can be used to trigger actions.
    ///
    /// - Parameters:
    ///   - memoDepth: An array representing the hierarchical depth of selected views.
    ///   - section: The index of the section being queried.
    /// - Returns: A `String` representing the event identifier, or `nil` if no event is found.
    func loadEvent(on memoDepth: [Int], and section: Int) -> String?
    
    /// Determines whether the last section of the current depth is reachable.
    ///
    /// This method checks if the user has navigated to the final section of the current hierarchical level.
    ///
    /// - Parameters:
    ///   - memoDepth: An array representing the hierarchical depth of selected views.
    ///   - section: The index of the section being queried.
    /// - Returns: A `Bool` indicating whether the last section is reachable, or `nil` if the state is indeterminate.
    func isLastSectionReachable(on memoDepth: [Int], and section: Int) -> Bool?
    
    /// Calculates the number of sections available at the current hierarchical depth.
    ///
    /// This method is used to determine the total number of sections for the view depth currently being focused on.
    ///
    /// - Parameter memoDepth: An array representing the hierarchical depth of selected views.
    /// - Returns: An `Int` representing the number of sections, or `nil` if the calculation cannot be performed.
    func calculateSectionsAtDepth(on memoDepth: [Int]) -> Int?
}
