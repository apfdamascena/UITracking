//
//  CommandeyeTrackerBusTest.swift
//  eye-trackingTests
//
//  Created by alexdamascena on 23/12/24.
//

import XCTest
@testable import eye_tracking


class EyeTrackingViewControllerMock: EyeTrackingViewController {
    
    init(){
        
        let tracking = EyeTracking(configuration: Configuration())
        let interpreter = TracingInterpreterImpl()
        let comandBus =  CommandEyeTrackerBusImpl()
        
        let adapter = EyeTrackingAdapter(tracker: tracking,
                                          interpreter: interpreter)
        
        let datasource = EyeTrackingDatasourceImpl(tracking: tracking,
                                                   trackerAdapter: adapter,
                                                   commandBus: comandBus,
                                                   interpreter: interpreter)
        
        super.init(view: EyeTrackingView(),
                   datasource: datasource,
                   delegate: EyeTrackingDelegateImpl())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EyeTrackerEventHandlerMock: EyeTrackerEventHandler {
    
    static var event: String = "test-event"
    
    var isExecuteCalled = false
    
    func execute(on controller: eye_tracking.EyeTrackingViewController) {
        isExecuteCalled = true
    }
}

final class CommandEyeTrackerBusTest: XCTestCase {
    
    typealias SUT = (CommandEyeTrackerBusImpl, EyeTrackerEventHandlerMock)
    
    func makeSUT() -> SUT {
        let handler = EyeTrackerEventHandlerMock()
        let command = CommandEyeTrackerBusImpl()
        return (command, handler)
    }

    func testRegisterEventHandler(){
        let (command, handler) = makeSUT()
        command.registerEvent(EyeTrackerEventHandlerMock.event,
                              handler: handler)
        
        XCTAssertEqual(command.events.keys.count, 1)
    }
    
    func testDeleteEventHandler() {
        let (command, handler) = makeSUT()
        command.registerEvent(EyeTrackerEventHandlerMock.event,
                              handler: handler)
        
        XCTAssertEqual(command.events.keys.count, 1)
        
        command.deleteEvent(EyeTrackerEventHandlerMock.event)
        
        XCTAssertEqual(command.events.keys.count, 0)
    }
    
    func testHandlerExecution(){
        let (command, handler) = makeSUT()
        command.registerEvent(EyeTrackerEventHandlerMock.event,
                              handler: handler)
        
        
        
        command.executeEvent(EyeTrackerEventHandlerMock.event, controller: EyeTrackingViewControllerMock())
        
        XCTAssertTrue(handler.isExecuteCalled)
    }

}
