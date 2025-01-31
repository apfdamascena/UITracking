//
//  EyeTrackingViewControllerFlowTest.swift
//  eye-trackingTests
//
//  Created by alexdamascena on 25/12/24.
//


import XCTest
@testable import eye_tracking

final class EyeTrackingViewControllerFlowTest: XCTestCase {
    
    typealias SUT = (EyeTrackingViewController,
                     TrackerAdapterMock,
                     InterpreterMock,
                     TrackingMock,
                     EyeMovePresenterMock)
    
    func makeSUT() -> SUT {
        let view = EyeTrackingTreeViewBuilder()
            .addSection{ node in
                node
                    .addView(ViewMock())
                    .addView(ViewMock())
                
            }.addSection{ node in
                node.addViewWithEvent(ViewMock(), event: EventMock.event)
            }.build()
        
        let commandBus = CommandBusMock()
        
        let eventMock = EventMock()
        
        commandBus.registerEvent(EventMock.event, handler: eventMock)
    
        let tracking = TrackingMock()
        let interpreter = InterpreterMock()
        let adapter = TrackerAdapterMock(tracker: tracking,
                                     interpreter: interpreter)

        
        let datasource = EyeTrackingDatasourceImpl(tracking: tracking,
                                                   trackerAdapter: adapter,
                                                   commandBus: commandBus,
                                                   interpreter: interpreter)
        
        
        let delegate = EyeTrackingDelegateMock()
        let presenter = EyeMovePresenterMock()
        
        let controller = EyeTrackingViewController(view: view,
                                         datasource: datasource,
                                         delegate: delegate,
                                         presenter: presenter)
        
        return (controller, adapter, interpreter, tracking, presenter)
    
    }

    func testEyeMovementNavigation(){
        let (controller, adapter, interpreter, tracking, presenter) = makeSUT()
        tracking.startFakeEyeMovement()
        
        XCTAssertTrue(adapter.isSendCoordinatesCalled)
        XCTAssertTrue(interpreter.isInterpretEyeMovementCalled)
        XCTAssertEqual(interpreter.pointer, CGPoint(x: 50, y: 50))
        XCTAssertTrue(presenter.isDrawFocusAreaCalled)
    }
    
    func testEyeBlinkEyeNavigation(){
        let (controller, adapter, interpreter, tracking, presenter) = makeSUT()
        tracking.startFakeBlinkEyes()
        
        XCTAssertTrue(adapter.isBlinkCalled)
        XCTAssertTrue(interpreter.isInterpretEyeMovementCalled)
        XCTAssertEqual(interpreter.pointer, CGPoint(x: 50, y: 50))
        XCTAssertEqual(controller.datasource.depths.count, 1)
        
    }


}
