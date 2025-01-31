//
//  EyeTrackingARSessionDelegateTest.swift
//  eye-trackingTests
//
//  Created by alexdamascena on 17/12/24.
//


import XCTest
import ARKit
@testable import eye_tracking

class EyeTrackerDelegateMock: EyeTrackerDelegate {
    
    var isSendCoordinatesCalled: Bool = false
    var isBlinkCalled: Bool = false
    var argument: CGPoint = .zero
    
    func sendCoordinates(point: CGPoint) {
        argument = point
        isSendCoordinatesCalled = true
    }
    
    func blink(at point: CGPoint) {
        argument = point
        isBlinkCalled = true
    }
}


final class EyeTrackingARSessionDelegateTest: XCTestCase {
    
    typealias SUT = (EyeTracking, EyeTrackerDelegateMock)
    
    func makeSUT() -> SUT {
        let eyetracking = EyeTracking(configuration: Configuration())
        let trackerDelegate = EyeTrackerDelegateMock()
        eyetracking.eyeMovementDelegate = trackerDelegate
        return (eyetracking, trackerDelegate)
    }

    func testSuccessfullySendCoordinates() throws {
        let (eyetracking, delegate) = makeSUT()
        let fakePoint = CGPoint(x: 10, y: 10)
        eyetracking.updateCoordinates(point: fakePoint)
        XCTAssertTrue(delegate.isSendCoordinatesCalled)
        XCTAssertEqual(delegate.argument.x, fakePoint.x)
        XCTAssertEqual(delegate.argument.y, fakePoint.y)
    }
    
    func testSuccessfullySendBlinkedEyes(){
        let (eyetracking, delegate) = makeSUT()
        let fakePoint = CGPoint(x: 10, y: 10)
        
        let fakeBlinkedEyes = NSNumber(floatLiteral: 0.85)
        
        eyetracking.blinkedEyesTimes = Array(repeating: 0.95, count: 30)
        
        eyetracking.updateBlinkEyesAt(fakeBlinkedEyes,
                                      at: fakePoint)
        
        let expectation = XCTestExpectation(description: "Waiting for removeAll and delegate call")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            XCTAssertTrue(delegate.isBlinkCalled)
            XCTAssertEqual(delegate.argument.x, fakePoint.x)
            XCTAssertEqual(delegate.argument.y, fakePoint.y)
            XCTAssertEqual(eyetracking.blinkedEyesTimes.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
}
