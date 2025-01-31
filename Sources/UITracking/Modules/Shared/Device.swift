//
//  DeviceInfo.swift
//  eye-chat
//
//  Created by alexdamascena on 10/12/23.
//

import UIKit


@MainActor
public struct Device: Codable {
    private(set) var model = UIDevice.current.modelName
    private(set) var screenSize = UIScreen.main.fixedCoordinateSpace.bounds.size
}

extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
