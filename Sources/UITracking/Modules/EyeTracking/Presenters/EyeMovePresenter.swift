//
//  EyeMovePresenter.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import Foundation

public class EyeMovePresenter: EyeMovePresentable {

    var view: EyeMoveView?
        
    func drawFocusArea(for section: Int, on memoDepth: [Int]) {
        view?.removeBorder()
        let depthStart = 0
        _ = view?.drawBorder(on: section,
                         and: depthStart,
                         memoDepth: memoDepth)
    }
        
    func calculateSectionsAtDepth(on memoDepth: [Int]) -> Int? {
        return view?.getSectionViewsQuantity(on: memoDepth)
    }
    
    
    func isLastSectionReachable(on memoDepth: [Int], and section: Int) -> Bool? {
        return view?.isLastView(on: memoDepth, and: section)
    }
    
    
    func loadEvent(on memoDepth: [Int], and section: Int) -> String? {
        return view?.getEvent(on: memoDepth,
                              and: section)
    }
}
