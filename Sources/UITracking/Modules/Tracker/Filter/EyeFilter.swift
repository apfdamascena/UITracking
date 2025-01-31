//
//  LowPassFilter.swift
//  eye-chat
//
//  Created by alexdamascena on 10/12/23.
//

import UIKit


class EyeFilter {
    
    private(set) var position: CGFloat
    let filterValue: CGFloat
    
    init(position: CGFloat, filterValue: CGFloat) {
        self.position = position
        self.filterValue = filterValue
    }

     func filter(with value: CGFloat) {

         self.position = filterValue * self.position + (1 - filterValue) * value
    }
}
