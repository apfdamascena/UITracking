//
//  EyeAction.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import Foundation

/// Enum that defines the possible actions in the eye-tracking system.
///
/// The `EyeAction` enum represents various actions that can be performed in an eye-tracking interface, such as selecting or deselecting views,
/// or popping a view from the current selection stack.
enum EyeAction {
    
    /// Represents the action of selecting a view or element.
    case select
    
    /// Represents the action of deselecting a view or element.
    case deselect
    
    /// Represents the action of popping a view or element from the selection stack.
    case pop
}

