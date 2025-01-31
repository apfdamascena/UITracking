//
//  EyeTrackingSessionTest.swift
//  eye-trackingTests
//
//  Created by alexdamascena on 17/12/24.
//

import XCTest
@testable import eye_tracking


final class EyeTrackingSessionTest: XCTestCase {
    
    typealias SUT = (EyeTracking, Configuration)
    
    func makeSUT() -> SUT {
        let configuration = Configuration()
        return (EyeTracking(configuration: configuration), configuration)
    }

    func testSuccessfullyStartSession() throws {
        let (eyetracking, configuration) = makeSUT()
        eyetracking.startSession()
        XCTAssertNotNil(eyetracking.currentSession)
        XCTAssertNotNil(eyetracking.arSession.delegate)
        XCTAssertEqual(configuration.appID, eyetracking.currentSession?.appID)
        XCTAssertNil(eyetracking.currentSession?.endTime)
    }
    
    func testSuccessfullyEndSession() throws {
        let (eyetracking, configuration) = makeSUT()
        eyetracking.startSession()
        XCTAssertEqual(configuration.appID, eyetracking.currentSession?.appID)
        eyetracking.endSession()
        XCTAssertNil(eyetracking.currentSession)
        XCTAssertNil(eyetracking.pointerFilter)
    }
}
