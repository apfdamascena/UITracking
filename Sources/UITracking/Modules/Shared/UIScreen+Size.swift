//
//  UIScreen+Size.swift
//  eye-tracking
//
//  Created by alexdamascena on 25/08/24.
//

import UIKit

public extension UIScreen {
    
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
    
    static let midWidth = screenWidth / 2
    static let midHeight = screenHeight / 2
}
