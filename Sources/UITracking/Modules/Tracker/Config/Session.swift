//
//  Session.swift
//  eye-chat
//
//  Created by alexdamascena on 10/12/23.
//

import Foundation


@MainActor
public struct Session: Codable {
    
    let id: String
    let appID: String
    private(set) var device = Device()

    var beginTime = Date().timeIntervalSince1970
    var endTime: TimeInterval?
}
