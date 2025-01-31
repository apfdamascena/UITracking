//
//  EyeTrackingDelegateTest.swift
//  eye-trackingTests
//
//  Created by alexdamascena on 25/12/24.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import eye_tracking

final class EyeTrackingDelegateTest: XCTestCase {
    
    typealias SUT = (EyeTrackingDelegateImpl, DisposeBag)
    
    
    func makeSUT() -> SUT {
        return (EyeTrackingDelegateImpl(), DisposeBag())
    }


    func testUserTappedGoBackEmitsEvent(){
        let (delegate, disposeBag) = makeSUT()
        
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)
        
        delegate.popActionSubject
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        
        delegate.userTappedGoBack()
        
         let events = observer.events
         XCTAssertEqual(events.count, 1)
         XCTAssertNotNil(events.first?.value.element)
    }
}
