//
//  EyeTrackingViewControllerTest.swift
//  eye-trackingTests
//
//  Created by alexdamascena on 25/12/24.
//

import XCTest
@testable import eye_tracking


class ViewMock: EyeTrackingView {
    
}

class EventMock: EyeTrackerEventHandler {
    static var event: String = "fake-handler"
    var isExecutedCalled = false
    
    func execute(on controller: eye_tracking.EyeTrackingViewController) {
        isExecutedCalled = true
    }
}

class CommandBusMock: CommandEyeTrackerBusImpl {
    
    var isRegisterEventCalled = false
    var isExecuteCalled = false
    var isDeleteCalled  = false
    
    override func registerEvent(_ event: String, handler: any EyeTrackerEventHandler) {
        isRegisterEventCalled = true
        super.registerEvent(event, handler: handler)
    }
    
    override func executeEvent(_ event: String, controller: EyeTrackingViewController) {
        isExecuteCalled = true
        super.executeEvent(event, controller: controller)
    }
    
    override func deleteEvent(_ event: String) {
        isDeleteCalled = true
        super.deleteEvent(event)
    }
}

class TrackingMock: EyeTracker {
    var eyeMovementDelegate: (any eye_tracking.EyeTrackerDelegate)?
    
    enum TestFlow {
        
    }
    
    func showPointer() {}
    
    func hidePointer() {}
    
    func startSession() {}
    
    func endSession() {}
    
    func startFakeEyeMovement(){
        let fakePoint = CGPoint(x: 50, y: 50)
        eyeMovementDelegate?.sendCoordinates(point: fakePoint)
    }
    
    func startFakeBlinkEyes(){
        let fakePoint = CGPoint(x: 50, y: 50)
        eyeMovementDelegate?.blink(at: fakePoint)
    }
    
    func isEyeTrackingSupported() -> Bool {
        return true
    }
}

class TrackerAdapterMock: EyeTrackingAdapter {
    
    var isSendCoordinatesCalled = false
    var isBlinkCalled = false
    
    override func sendCoordinates(point: CGPoint) {
        isSendCoordinatesCalled = true
        super.sendCoordinates(point: point)
    }
    
    override func blink(at point: CGPoint) {
        isBlinkCalled = true
        super.blink(at: point)
    }
}

class InterpreterMock: TracingInterpreterImpl {
    
    var isInterpretEyeMovementCalled = false
    var isInterpretEyeActionCalled = false
    var pointer: CGPoint = .zero
    
    override func interpretEyeMovement(with point: CGPoint) -> Int {
        isInterpretEyeMovementCalled = true
        pointer = point
        return super.interpretEyeMovement(with: point)
    }
    
    override func interpretEyeAction(with point: CGPoint) -> EyeAction? {
        pointer = point
        isInterpretEyeActionCalled = true
        return super.interpretEyeAction(with: point)
    }
}

class EyeTrackingDelegateMock: EyeTrackingDelegateImpl {
    
    var isUserTappedGoBackCalled = false
    
    override func userTappedGoBack() {
        isUserTappedGoBackCalled = true
    }
}

class EyeMovePresenterMock: EyeMovePresenter {
    
    var isDrawFocusAreaCalled = false
    var isLastSectionReachableCalled = false
    var isCalculateSectionsAtDepthCalled = false
    var isLoadEventCalled = false
    var memoDepth: [Int]?
    var section: Int?
    
    var isLastSectionReachableResult: Bool?
    var calculateSectionsAtDepthResult: Int?
    var loadEventResult: String?
    
    override func drawFocusArea(for section: Int, on memoDepth: [Int]) {
        isDrawFocusAreaCalled = true
        self.memoDepth = memoDepth
        self.section = section
        super.drawFocusArea(for: section, on: memoDepth)
    }
    
    override func isLastSectionReachable(on memoDepth: [Int], and section: Int) -> Bool? {
        isLastSectionReachableCalled = true
        self.memoDepth = memoDepth
        self.section = section
        let result = super.isLastSectionReachable(on: memoDepth, and: section)
        self.isLastSectionReachableResult = result
        return result
    }
    
    override func calculateSectionsAtDepth(on memoDepth: [Int]) -> Int? {
        isCalculateSectionsAtDepthCalled = true
        self.memoDepth = memoDepth
        let result = super.calculateSectionsAtDepth(on: memoDepth)
        self.calculateSectionsAtDepthResult = result
        return result
    }
    
    override func loadEvent(on memoDepth: [Int], and section: Int) -> String? {
        isLoadEventCalled = true
        self.memoDepth = memoDepth
        self.section = section
        let result = super.loadEvent(on: memoDepth, and: section)
        self.loadEventResult = result
        return result
    }
    
}


final class EyeTrackingViewControllerTest: XCTestCase {
    
    typealias SUT = (EyeTrackingViewController, 
                     EyeMovePresenterMock,
                     EyeTrackingDatasourceImpl,
                     EventMock,
                     EyeTrackingDelegateMock
    )
    
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
        return (controller, presenter, datasource, eventMock, delegate)
    }

    func testUserMoveFocusArea() throws {
        let (controller, presenter, _, _, _) = makeSUT()
        let fakeMove = 0
        
        controller.onEyeMovement(fakeMove)
        
        XCTAssertNotNil(controller.presenter)
        XCTAssertTrue(presenter.isDrawFocusAreaCalled)
        XCTAssertEqual(presenter.memoDepth?.count, 0)
        XCTAssertEqual(presenter.section, 0)
    }
    
    func testUserSelectFocusedArea(){
        let (controller, presenter, datasource, _, _) = makeSUT()
        let fakeFocusedArea = 0
        
        controller.onEyeAction(.select, fakeFocusedArea)
        
        XCTAssertEqual(datasource.depths.count, 1)
        XCTAssertTrue(presenter.isCalculateSectionsAtDepthCalled)
        XCTAssertEqual(presenter.calculateSectionsAtDepthResult!, 2)
    }
    
    func testUserSelectFocusedAreaWithEventHandler(){
        
        let (controller, presenter, datasource, event, _) = makeSUT()
        let userChosenAreaWithEvent = [1]
        datasource.depths = userChosenAreaWithEvent
        let fakeFocusedArea = 0
        
        controller.onEyeAction(.select, fakeFocusedArea)
        
        XCTAssertEqual(datasource.depths.count, 0)
        XCTAssertTrue(presenter.isLoadEventCalled)
        XCTAssertEqual(presenter.loadEventResult!, "fake-handler")
        XCTAssertTrue(event.isExecutedCalled)
        XCTAssertFalse(presenter.isCalculateSectionsAtDepthCalled)
        XCTAssertTrue(presenter.isDrawFocusAreaCalled)
    }
    
    
    func testUserDeselectFocusedArea(){
        let (controller, presenter, datasource, _, _) = makeSUT()
        let userChosenAreaWithEvent = [1]
        datasource.depths = userChosenAreaWithEvent
        let fakeFocusedArea = 0
        
        XCTAssertEqual(datasource.depths.count, 1)
        
        controller.onEyeAction(.deselect, fakeFocusedArea)
        
        XCTAssertEqual(datasource.depths.count, 0)
        XCTAssertTrue(presenter.isCalculateSectionsAtDepthCalled)
        XCTAssertEqual(presenter.calculateSectionsAtDepthResult!, 2)
        XCTAssertTrue(presenter.isDrawFocusAreaCalled)
        
    }
    
    
    func testUserPopViewController(){
        let (controller, presenter, datasource, _, delegate) = makeSUT()
        let fakeFocusedArea = 0
        
        controller.onEyeAction(.pop, fakeFocusedArea)
        XCTAssertTrue(delegate.isUserTappedGoBackCalled)
    }
}
