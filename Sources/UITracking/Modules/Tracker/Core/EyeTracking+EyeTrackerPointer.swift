//
//  EyeTracking+EyeTrackerPointer.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import UIKit

extension EyeTracking: @preconcurrency EyeTrackerPointer {
    
    public func showPointer() {
        EyeTracking.window.addSubview(pointer)
    }

    public func hidePointer() {
        pointer.removeFromSuperview()
    }

    @objc func updatePointPosition(with point: CGPoint) -> CGPoint {
        
        let size = UIScreen.main.bounds.size
        
        let adjusted: (x: CGFloat, y: CGFloat) = (
            (size.width - point.x),
            (size.height - point.y)
        )
        
        guard let pointerFilter = pointerFilter else {
            pointerFilter = (
                EyeFilter(position: adjusted.x, filterValue: 0.85),
                EyeFilter(position: adjusted.y, filterValue: 0.85)
            )
            return point
        }
        
        pointerFilter.x.filter(with: adjusted.x)
        pointerFilter.y.filter(with: adjusted.y)

        pointer.frame = CGRect(
            x: pointerFilter.x.position,
            y: pointerFilter.y.position,
            width: pointer.frame.width,
            height: pointer.frame.height
        )
        
        
        return CGPoint(x: pointerFilter.x.position, y: pointerFilter.y.position)
    }
}
