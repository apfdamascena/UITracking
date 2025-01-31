//
//  EyeTrackingInterpreterTest.swift
//  eye-trackingTests
//
//  Created by alexdamascena on 18/12/24.
//
import XCTest
@testable import eye_tracking

final class EyeTrackingInterpreterTest: XCTestCase {
    
    
    typealias SUT = (EyeTracingInterpreter)
    
    func makeSUT() -> SUT {
        return TracingInterpreterImpl()
    }
    
    func testInterpretationWhenUserFocusedOnTopSection() {
        let (interpreter) = makeSUT()
        let screenDividedInTwoSections = 2
        let fakeLook = CGPoint(x: 50, y: 50)
        let firstSection = 0
        
        interpreter.setSectionViewQuantity(screenDividedInTwoSections)
        
        let sectionInterpreted = interpreter.interpretEyeMovement(with: fakeLook)
        XCTAssertEqual(sectionInterpreted, firstSection)
    }
    
    func testInterpretationWhenUserFocsuedOnDownSection(){
        let (interpreter) = makeSUT()
        let screenDividedInTwoSections = 2
        let fakeLook = CGPoint(x: 50, y: 800)
        let secondSection = 1
        
        interpreter.setSectionViewQuantity(screenDividedInTwoSections)
        let sectionInterpreted = interpreter.interpretEyeMovement(with: fakeLook)
        XCTAssertEqual(sectionInterpreted, secondSection)
    }
    
    func testInterpretationWhenUserDeselectFocusedArea(){
        let (interpreter) = makeSUT()
        let fakeLook = CGPoint(x: 50, y: -10)
        
        let action = interpreter.interpretEyeAction(with: fakeLook)
        
        XCTAssertEqual(action, .deselect)
        
    }
    
    func testInterpretationWhenUserPopView(){
        let (interpreter) = makeSUT()
        let fakeLook = CGPoint(x: -50, y: 10)
        
        let action = interpreter.interpretEyeAction(with: fakeLook)
        
        XCTAssertEqual(action, .pop)
    }
    

    func testInterpretationWhenUserDontMakeAction(){
        let (interpreter) = makeSUT()
        let fakeLook = CGPoint(x: 10, y: 10)
        
        let action = interpreter.interpretEyeAction(with: fakeLook)
        
        XCTAssertNil(action)
    }
}
