//
//  Configuration.swift
//  eye-chat
//
//  Created by alexdamascena on 10/12/23.
//

import ARKit

public struct Configuration {

    let appID: String
    var gazeLog: GazeLogStatus
    
    init(blendShapes: [ARFaceAnchor.BlendShapeLocation]? = nil,
         gazeLogStatus: GazeLogStatus? = nil) {
        self.gazeLog = gazeLogStatus ?? .deactivate
        self.appID =  Bundle.main.bundleIdentifier ?? UUID().uuidString
    }
}
