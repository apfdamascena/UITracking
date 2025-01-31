//
//  EyeTrackingViewTest.swift
//  eye-trackingTests
//
//  Created by alexdamascena on 23/12/24.
//

import XCTest
@testable import eye_tracking


class ViewTest: EyeTrackingView {
    
    var label: UILabel {
        let label = UILabel(frame: .zero)
        label.text = "testing"
        return label
    }
}

final class EyeTrackingViewTest: XCTestCase {
    
    typealias SUT = (EyeTrackingView, (ViewTest, ViewTest))
    
    func makeSUT() -> SUT {
        
        let left = ViewTest()
        let right = ViewTest()
        
        let view = EyeTrackingTreeViewBuilder()
            .addSection{ node in
                node.addView(left)
            }
            .addSection{ node in
                node.addViewWithEvent(right, event: "fake-teste")
            }.build()
        
        
        return (view, (left, right))
    }
    
    
    func testViewCreation(){
        let (view, _) = makeSUT()
        XCTAssertEqual(view.subTrackingViews.count, 2)
    }
    
    func testViewEventCreation(){
        let (view, (left, right)) = makeSUT()
        XCTAssertEqual(view.subTrackingViews.count, 2)
        XCTAssertNil(left.event)
        XCTAssertEqual(right.event!, "fake-teste")
        
    }
    
    func testNewContentOnView(){
        let (_, (left, _)) = makeSUT()
        XCTAssertEqual(left.label.text, "testing")
    }
}
