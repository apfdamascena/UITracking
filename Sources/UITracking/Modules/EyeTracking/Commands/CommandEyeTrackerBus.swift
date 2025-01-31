//
//  CommandEyeTrackerBus.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import Foundation

class CommandEyeTrackerBusImpl: CommandEyeTrackerBus {
    var events: [String : any EyeTrackerEventHandler] = [:]
    
    func registerEvent(_ event: String, handler: any EyeTrackerEventHandler) {
        events.updateValue(handler, forKey: event)
    }
    
    func deleteEvent(_ event: String) {
        events.removeValue(forKey: event)
    }
    
    func executeEvent(_ event: String, controller: EyeTrackingViewController) {
        events[event]?.execute(on: controller)
    }
}
