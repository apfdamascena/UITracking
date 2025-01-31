//
//  EyeTrackingView+EyeMoveInformable.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import Foundation

/// Extension that conforms `EyeTrackingView` to the `EyeMoveInformable` protocol.
///
/// This extension provides functionality to retrieve event information, check whether a view is the last in a hierarchical structure,
/// and get the quantity of section views at specific levels of depth within the eye-tracking view hierarchy.
extension EyeTrackingView: @preconcurrency EyeMoveInformable {
    
    /// Retrieves the event associated with a specific view at a given depth and section in the hierarchy.
    ///
    /// This method supports navigating through a hierarchical structure of `EyeTrackingView` instances,
    /// retrieving the event associated with a particular view at a specified section and depth.
    ///
    /// - Parameters:
    ///   - memoDepth: An array representing the path to the target view, used for recursive traversal.
    ///   - section: The section index of the current view in the `subTrackingViews` array.
    ///
    /// - Returns: A `String?` representing the event associated with the specified view, or `nil` if no event is found.
    func getEvent(on memoDepth: [Int], and section: Int) -> String? {
        if memoDepth.isEmpty {
            // If memoDepth is empty, return the event for the current section.
            return subTrackingViews[section].event
        }
        
        var tempMemoDepth = memoDepth
        let indexComponent = tempMemoDepth.removeFirst()
        
        // Recursively traverse the subTrackingViews hierarchy to retrieve the event.
        return subTrackingViews[indexComponent].getEvent(on: tempMemoDepth,
                                                         and: section)
    }
    
    /// Checks whether the current view is the last view at a given depth and section.
    ///
    /// This method recursively checks if the view at the specified section and depth is the last in the `subTrackingViews` array,
    /// considering the hierarchy of nested `EyeTrackingView` instances.
    ///
    /// - Parameters:
    ///   - memoDepth: An array representing the path to the target view, used for recursive traversal.
    ///   - section: The section index of the current view in the `subTrackingViews` array.
    ///
    /// - Returns: A `Bool` indicating whether the current view is the last in the hierarchy at the specified depth and section.
    func isLastView(on memoDepth: [Int], and section: Int) -> Bool {
        
        if memoDepth.isEmpty {
            // If memoDepth is empty, return true if the current section has no subviews.
            return subTrackingViews[section].subTrackingViews.count == 0
        }
        
        var isLastView = false
        var tempMemoDepth = memoDepth
        let indexComponent = tempMemoDepth.removeFirst()
        
        // Recursively check the subTrackingViews hierarchy for the last view.
        isLastView = isLastView || subTrackingViews[indexComponent].isLastView(on: tempMemoDepth, and: section)
        
        return isLastView
    }
    
    /// Retrieves the total number of section views at a given depth in the hierarchy.
    ///
    /// This method supports traversing the `EyeTrackingView` hierarchy to determine the number of views at a specific level of depth.
    ///
    /// - Parameter memoDepth: An array representing the path to the target view, used for recursive traversal.
    ///
    /// - Returns: The number of section views at the specified depth level. If no views are found at the target depth, it defaults to 1.
    func getSectionViewsQuantity(on memoDepth: [Int]) -> Int {
        
        if memoDepth.isEmpty {
            // If memoDepth is empty, return the count of subviews at the current level.
            return subTrackingViews.count == 0 ? 1 : subTrackingViews.count
        }
        
        var tempMemoDepth = memoDepth
        let indexComponent = tempMemoDepth.removeFirst()
                
        // Recursively retrieve the quantity of section views at the specified depth.
        return subTrackingViews[indexComponent].getSectionViewsQuantity(on: tempMemoDepth)
    }
}

