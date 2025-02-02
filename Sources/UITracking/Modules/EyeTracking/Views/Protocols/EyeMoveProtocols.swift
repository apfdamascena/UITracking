//
//  EyeMoveProtocols.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import Foundation

/// A protocol that defines methods for managing visual feedback in the eye-tracking system.
///
/// The `EyeMoveViewable` protocol provides functionality to visually highlight or reset sections
/// of the view hierarchy based on eye-tracking interactions.
public protocol EyeMoveViewable {
    
    /// Draws a border around a specific section of the view hierarchy.
    ///
    /// - Parameters:
    ///   - section: The index of the section to highlight.
    ///   - depth: The depth level in the view hierarchy for the section.
    ///   - memoDepth: A list of indices representing the previously selected sections.
    /// - Returns: An updated index or depth to reflect the current state of the view.
    func drawBorder(on section: Int,
                    and depth: Int,
                    memoDepth: [Int]) -> Int

    /// Removes any visual borders or highlights from the view.
    ///
    /// This is used to reset the visual state of the view when no sections are being highlighted.
    func removeBorder()
}

/// A protocol that defines methods for retrieving and interpreting information about the view hierarchy.
///
/// The `EyeMoveInformable` protocol provides methods to access information related to sections,
/// their relationships, and associated events in the eye-tracking context.
public protocol EyeMoveInformable {
    
    /// Retrieves the number of sections at a given depth in the view hierarchy.
    ///
    /// - Parameter memoDepth: A list of indices representing the current selection path in the hierarchy.
    /// - Returns: The number of sections available at the specified depth.
    func getSectionViewsQuantity(on memoDepth: [Int]) -> Int
    
    /// Determines whether a specified section is the last selectable section at the given depth.
    ///
    /// - Parameters:
    ///   - memoDepth: A list of indices representing the current selection path in the hierarchy.
    ///   - section: The index of the section to check.
    /// - Returns: A Boolean indicating whether the section is the last one.
    func isLastView(on memoDepth: [Int], and section: Int) -> Bool
    
    /// Retrieves the event identifier associated with a specific section and depth.
    ///
    /// - Parameters:
    ///   - memoDepth: A list of indices representing the current selection path in the hierarchy.
    ///   - section: The index of the section to retrieve the event for.
    /// - Returns: A string representing the event identifier, or `nil` if no event is associated.
    func getEvent(on memoDepth: [Int], and section: Int) -> String?
}

/// A typealias combining the visual management (`EyeMoveViewable`) and informational (`EyeMoveInformable`) protocols.
///
/// The `EyeMoveView` type represents a view component capable of providing both visual feedback
/// and hierarchical information for the eye-tracking system.
public typealias EyeMoveView = EyeMoveViewable & EyeMoveInformable

