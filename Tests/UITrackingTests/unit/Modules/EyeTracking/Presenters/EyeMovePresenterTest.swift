//
//  EyeMovePresenterTest.swift
//  eye-trackingTests
//
//  Created by alexdamascena on 23/12/24.
//

import XCTest
@testable import eye_tracking


class EyeTrackingViewMock: EyeTrackingView {
    
    var isDrawBorderCalled = false
    var isRemoveBorderCalled = false
    
    override func drawBorder() {
        isDrawBorderCalled = true
        super.drawBorder()
    }
    
    override func removeBorder() {
        isRemoveBorderCalled = true
        super.removeBorder()
    }
}

final class EyeMovePresenterTest: XCTestCase {
    
    typealias SUT = (EyeMovePresenter, EyeTrackingViewMock, (EyeTrackingViewMock, EyeTrackingViewMock))
    
    func makeSUT() -> SUT {
        let left = EyeTrackingViewMock()
        let right = EyeTrackingViewMock()
        right.event = "fake-event"
        let mockView = EyeTrackingViewMock(subTrackingViews: [left, right])
        let presenter = EyeMovePresenter()
        presenter.view = mockView
        return (presenter, mockView, (left, right))
    }

    func testDrawFocusAreaOnEyeTrackingView() throws {
        let (presenter, view, (left, _)) = makeSUT()
        let section = 0
        presenter.drawFocusArea(for: section, on: [])
        
        XCTAssertTrue(view.isRemoveBorderCalled)
        XCTAssertTrue(left.isDrawBorderCalled)
        XCTAssertEqual(left.layer.borderWidth, 2.0)
    }
    
    func testIsLastViewReacheableOnEyeTrackingView() {
        let (presenter, _ , _ ) = makeSUT()
        let section = 0
        let memoDepth: [Int] = []
        
        let isReachable = presenter.isLastSectionReachable(on: memoDepth,
                                         and: section)
        XCTAssertTrue(isReachable!)
    }
    
    func testSectionCalculationOnEyeTrackingView(){
        let (presenter, view , _ ) = makeSUT()
        let memoDepth: [Int] = []
        let sections = presenter.calculateSectionsAtDepth(on: memoDepth)
        
        XCTAssertEqual(sections!, view.subTrackingViews.count)
    }
    
    func testLoadEventOnEyeTrackingView(){
        let (presenter, _ , (_, right) ) = makeSUT()
        let memoDepth: [Int] = []
        let section = 1
        let event = presenter.loadEvent(on: memoDepth, and: section)
        XCTAssertEqual(event!, right.event)
    }
}
