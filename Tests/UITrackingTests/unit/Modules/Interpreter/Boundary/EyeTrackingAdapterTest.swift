//
//  EyeTrackingAdapterTest.swift
//  eye-trackingTests
//
//  Created by alexdamascena on 19/12/24.
//

import XCTest
@testable import eye_tracking

enum EyeTrackerMoveTest {
    case eyeMove, blink
}

class EyeTrackerMock: EyeTracker {
    var eyeMovementDelegate: (any EyeTrackerDelegate)?
    var isEndSessionCalled = false
    var isStartSessionCalled = false
    var isShowPointerCalled = false
    var isHidePointerCalled = false
    var move: EyeTrackerMoveTest = .eyeMove
    
    func setTrackerMove(_ move: EyeTrackerMoveTest){
        self.move = move
    }
    
    func showPointer() {
        isShowPointerCalled = true
    }
    
    func hidePointer() {
        isHidePointerCalled = true
    }
    
    func startSession() {
        isStartSessionCalled = true
        let fakePoint = CGPoint(x: 10, y: 10)
    
        if move == .eyeMove {
            eyeMovementDelegate?.sendCoordinates(point: fakePoint)
        } else {
            eyeMovementDelegate?.blink(at: fakePoint)
        }
    }
    
    func endSession() {
        isEndSessionCalled = true
    }
    
    func isEyeTrackingSupported() -> Bool {
        return true
    }
}

class EyeTracingInterpreterAdapterMock: EyeTracingInterpreter {
    
    var isInterpretEyeMovementCalled = false
    var pointToInterpret: CGPoint = .zero
    
    var action: EyeAction?
    
    func interpretEyeMovement(with point: CGPoint) -> Int {
        isInterpretEyeMovementCalled = true
        pointToInterpret = point
        return 0
    }
    
    func interpretEyeAction(with point: CGPoint) -> EyeAction? {
        return self.action
    }
    
    func setInterpretEyeAction(action: EyeAction?){
        self.action = action
    }
    
    func setSectionViewQuantity(_ quantity: Int) {}
}

class EyeTracingInterpreterDelegateMock: EyeTracingInterpreterDelegate {
    
    var onEyeActionCalled = false
    var onEyeMovementCalled = false
    var sectionReceived = -1
    var actionReceived: EyeAction?
    
    func onEyeAction(_ action: EyeAction, _ section: Int) {
        onEyeActionCalled = true
        sectionReceived = section
        actionReceived = action
    }
    
    func onEyeMovement(_ section: Int) {
        sectionReceived = section
        onEyeMovementCalled = true
    }
}

final class EyeTrackingAdapterTest: XCTestCase {
    
    typealias SUT = (EyeTrackingAdapter, EyeTracingInterpreterAdapterMock, EyeTracingInterpreterDelegateMock)
    
    func makeSUT() -> SUT {
        let eyeTracker = EyeTrackerMock()
        let eyeTracingInterpreter = EyeTracingInterpreterAdapterMock()
        let delegate = EyeTracingInterpreterDelegateMock()
        let adapter = EyeTrackingAdapter(tracker: eyeTracker,
                                         interpreter: eyeTracingInterpreter)
        adapter.delegate = delegate
        return (adapter, eyeTracingInterpreter, delegate)
    }
    
    func testAdapterDetectBlinkEyes() throws {
        let (adapter, interpreter, delegate) = makeSUT()
        let fakePoint = CGPoint(x: 50, y: 50)
        
        adapter.blink(at: fakePoint)
        XCTAssertTrue(interpreter.isInterpretEyeMovementCalled)
        XCTAssertEqual(interpreter.pointToInterpret, fakePoint)
        
        XCTAssertTrue(delegate.onEyeActionCalled)
        XCTAssertEqual(delegate.sectionReceived, 0)
        XCTAssertEqual(delegate.actionReceived, .select)
    }
    
    func testAdapterDetectEyeMovement(){
        let (adapter, interpreter, delegate) = makeSUT()
        let fakePoint = CGPoint(x: 50, y: 50)
        let screenDividedInTwoSections = 2
        
        interpreter.setSectionViewQuantity(screenDividedInTwoSections)
        
        interpreter.setInterpretEyeAction(action: nil)
        adapter.sendCoordinates(point: fakePoint)
        
    
        XCTAssertTrue(interpreter.isInterpretEyeMovementCalled)
        XCTAssertEqual(interpreter.pointToInterpret, fakePoint)
        XCTAssertEqual(delegate.sectionReceived, 0)
    }
}

