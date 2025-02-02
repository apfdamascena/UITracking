//
//  EyeTracking.swift
//  eye-chat
//
//  Created by alexdamascena on 10/12/23.
//

import ARKit
import UIKit

@MainActor
class EyeTracking: NSObject, @preconcurrency EyeTrackerDataSource {

    var currentSession: Session?
    var eyeMovementDelegate: EyeTrackerDelegate?
    
    var arSession = ARSession()
    var configuration: Configuration
    
    var blinkedEyesTimes: [Double] = []
    var pointerFilter: (x: EyeFilter, y: EyeFilter)?
    
    static var window: UIWindow {
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else {
            assertionFailure("Call on viewDidAppear().")
            return UIWindow()
        }
        return window
    }

    public lazy var pointer: UIView = {
        let view = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2, width: 30, height: 30))
        view.layer.cornerRadius = view.frame.size.width / 2
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .blue
        view.layer.zPosition = .greatestFiniteMagnitude
        return view
    }()

    public required init(configuration: Configuration) {
        self.configuration = configuration
        super.init()
    }
}



