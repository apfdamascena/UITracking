//
//  EyeTrackingDatasourceImpl.swift
//  eye-tracking
//
//  Created by alexdamascena on 16/12/24.
//

import Foundation

public final class EyeTrackingDatasourceImpl: EyeTrackingDatasource {

    var tracking: any EyeTracker
    
    var trackerAdapter: EyeTrackingAdapter
    
    var commandBus: any CommandEyeTrackerBus
    
    var interpreter: any EyeTracingInterpreter
    
    var depths: [Int]
    
    init(tracking: any EyeTracker,
         trackerAdapter: EyeTrackingAdapter,
         commandBus: any CommandEyeTrackerBus,
         interpreter: any EyeTracingInterpreter,
         depths: [Int]? = nil) {
        self.tracking = tracking
        self.trackerAdapter = trackerAdapter
        self.commandBus = commandBus
        self.interpreter = interpreter
        self.depths = depths ?? []
    }
}
