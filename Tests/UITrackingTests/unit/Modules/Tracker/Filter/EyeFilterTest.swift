//
//  EyeFilterTest.swift
//  eye-trackingTests
//
//  Created by alexdamascena on 18/12/24.
//
import XCTest
@testable import eye_tracking

final class EyeFilterTest: XCTestCase {
    
    typealias SUT = (EyeFilter)
    
    func makeSUT() -> SUT {
        return EyeFilter(position: 100.0,
                         filterValue: 0.85)
    }

    func testFilterPositionAfterDetectEyeMovement() {
        let (filter) = makeSUT()
        let fakePosition: CGFloat = 150
        filter.filter(with: fakePosition)
        XCTAssertEqual(filter.position, 107.5)
    }
}
