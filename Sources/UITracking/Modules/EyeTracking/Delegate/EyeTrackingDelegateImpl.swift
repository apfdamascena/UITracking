//
//  EyeTrackingDelegateImpl.swift
//  eye-tracking
//
//  Created by alexdamascena on 16/12/24.
//

import Foundation
import RxSwift

class EyeTrackingDelegateImpl: EyeTrackingDelegate {
    
    var popActionSubject: RxSwift.PublishSubject<Void> = PublishSubject()
    
    func userTappedGoBack() {
        popActionSubject.onNext(())
    }
}
