//
//  EyeTrackingInterpreter.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import UIKit


public class TracingInterpreterImpl: @preconcurrency EyeTracingInterpreter {
    
    var viewsQuantity: Int = 1
    
    func setSectionViewQuantity(_ quantity: Int) {
        self.viewsQuantity = quantity
    }
    
    @MainActor func interpretEyeMovement(with point: CGPoint) -> Int {
        
        let screenSize = UIScreen.screenHeight
        let centralPointer = point.y
        
        let quadrantSize = screenSize / CGFloat(viewsQuantity)
        
        print(screenSize)
        print(quadrantSize)
        print(viewsQuantity)
        
        let sections = (1...viewsQuantity).map { CGFloat($0) * quadrantSize }
        
        let indexForView = sections.firstIndex(where: { section in
            return centralPointer < section
        })
        
        guard let viewTracked = indexForView else { return 0 }
        return viewTracked
    }
    
    func interpretEyeAction(with point: CGPoint) -> EyeAction? {
        
        if(point.y < 0){
            return .deselect
        }
        
        if(point.x < 0) {
            return .pop
        }
        
        return nil
    }
}
