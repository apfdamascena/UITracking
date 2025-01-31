//
//  EyeTrackingPointTracker.swift
//  eye-trackingTests
//
//  Created by alexdamascena on 17/12/24.
//

import XCTest
@testable import eye_tracking


final class EyeTrackingTrackerPointerTest: XCTestCase {
    
    typealias SUT = (EyeTracking)
    
    func makeSUT() -> SUT {
        return EyeTracking(configuration: Configuration())
    }

    func testAddPointerToEyetrackingView() throws {
        let (eyetracking) = makeSUT()
        let subviewsBefore = EyeTracking.window.subviews.count
        eyetracking.showPointer()
        XCTAssertEqual(EyeTracking.window.subviews.count, subviewsBefore + 1)
    }
    
    func testHidePointerToEyetrackingView() {
        let (eyetracking) = makeSUT()
        eyetracking.showPointer()
        let subviewsBefore = EyeTracking.window.subviews.count
        eyetracking.hidePointer()
        XCTAssertEqual(EyeTracking.window.subviews.count, subviewsBefore - 1)
    }
}
