//
//  EyeTracking+EyeTrackerSession.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import ARKit

extension EyeTracking: @preconcurrency EyeTrackerSession {

    public func startSession() {
        guard isEyeTrackingSupported() else {
            assertionFailure("Face tracking not supported.")
            return
        }
        
        guard currentSession == nil else {
            return
        }

        currentSession = Session(id: UUID().uuidString, appID: configuration.appID)

        let configuration = ARFaceTrackingConfiguration()
        configuration.worldAlignment = .camera

        arSession.delegate = self
        arSession.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    public func endSession() {
        arSession.pause()
        currentSession?.endTime = Date().timeIntervalSince1970
        self.currentSession = nil
        pointerFilter = nil
    }
    
    func isEyeTrackingSupported() -> Bool {
        return ARFaceTrackingConfiguration.isSupported
    }
}
