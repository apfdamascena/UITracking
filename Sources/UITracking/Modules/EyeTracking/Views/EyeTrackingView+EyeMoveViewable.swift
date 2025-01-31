//
//  EyeTrackingView+EyeMoveViewable.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import Foundation

/// Extension that conforms the `EyeTrackingView` to the `EyeMoveViewable` protocol.
///
/// This extension provides functionality for drawing and removing borders on the eye-tracking views,
/// which can be used to visually indicate areas that are being interacted with during the eye-tracking process.
/// It also supports a recursive approach for drawing borders across nested views in a hierarchical structure.
/// 
extension EyeTrackingView: @preconcurrency EyeMoveViewable {
    
    /// Draws a border around the view at a specified section and depth within a hierarchical structure.
    ///
    /// This method allows for drawing a border around specific areas (subsections) of the screen represented by `EyeTrackingView`.
    /// It handles recursive traversal through nested `EyeTrackingView` instances based on the `memoDepth` array,
    /// which defines the path to the current subsection.
    ///
    /// - Parameters:
    ///   - section: The index of the current section in the `subTrackingViews` array.
    ///   - depth: The current depth in the view hierarchy.
    ///   - memoDepth: An array that represents the path to the current view, used for recursive traversal.
    ///
    /// - Returns: The updated depth after drawing the border. If the section is not found, the border is drawn on the current view.
    func drawBorder(on section: Int, and depth: Int, memoDepth: [Int]) -> Int {
        
        // If the current depth is greater than or equal to the memoDepth count, draw the border on the current view.
        guard depth < memoDepth.count else {
            subTrackingViews[section].drawBorder()
            return depth
        }
        
        let componentIndex = memoDepth[depth]
        
        // Ensure the index exists in the subTrackingViews array.
        guard componentIndex < subTrackingViews.count else {
            subTrackingViews[section].drawBorder()
            return depth
        }
        
        // Get the next component (subview) to traverse and continue recursion.
        let component = subTrackingViews[componentIndex]
        
        // Recursively call drawBorder on the child view at the next depth level.
        return component.drawBorder(on: section, and: depth + 1, memoDepth: memoDepth)
    }
    
    /// Removes the border from the current view and all its subviews.
    ///
    /// This method resets the border properties of the view and removes any border decorations
    /// from the subviews by recursively calling `removeBorder()` on each child.
    @objc func removeBorder() {
        
        // Reset the border properties of the current view.
        self.layer.borderWidth = 0
        self.layer.borderColor = .none
        
        // Recursively call removeBorder on all child subviews.
        subTrackingViews.forEach { view in
            view.removeBorder()
        }
    }
}

