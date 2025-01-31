//
//  EyeTracking+ARSessionDelegate.swift
//  eye-tracking
//
//  Created by alexdamascena on 01/12/24.
//

import ARKit

@MainActor
extension EyeTracking: @preconcurrency ARSessionDelegate {
    
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let anchor = frame.anchors.first as? ARFaceAnchor else { return }
        let blinkedEyesLeft = anchor.blendShapes[.eyeBlinkLeft]
    
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return }

        let screenPoint = getScreenPoint(with: frame,
                                         given: orientation,
                                         andAnchor: anchor)
        
        logScreenPointIfEnabled(point: screenPoint)
        let pointerPositionFiltered = updatePointPosition(with: screenPoint)
        
        updateCoordinates(point: pointerPositionFiltered)
        updateBlinkEyesAt(blinkedEyesLeft, at: pointerPositionFiltered)
    }
    
    private func logScreenPointIfEnabled(point: CGPoint){
        if configuration.gazeLog == .activate {
            print("Screen Point: ", point, "at timestamp: ", Date())
        }
    }
    
    private func getScreenPoint(with frame: ARFrame,
                                given orientation: UIInterfaceOrientation,
                                andAnchor: ARFaceAnchor
    ) -> CGPoint {
        return frame.camera.projectPoint(
            SIMD3<Float>(x: lookVector(with: andAnchor).x,
                         y: lookVector(with: andAnchor).y,
                         z: lookVector(with: andAnchor).z),
            orientation: orientation,
            viewportSize: UIScreen.main.bounds.size
        )
    }
    
    private func lookVector(with anchor: ARFaceAnchor) -> SIMD4<Float> {
        return anchor.transform * SIMD4<Float>(anchor.lookAtPoint, 1)
    }
    
    func updateCoordinates(point: CGPoint) {
        eyeMovementDelegate?.sendCoordinates(point: point)
    }

    func updateBlinkEyesAt(_ blinkedEyesLeft:  NSNumber?, at point: CGPoint) {
        
        if blinkedEyesLeft?.decimalValue ?? 0.0 > 0.9 {
            blinkedEyesTimes.append(1.0)
        }
        
        if blinkedEyesTimes.count > 20 {
            
            DispatchQueue.main.async {
                self.blinkedEyesTimes.removeAll()
                self.eyeMovementDelegate?.blink(at: point)
            }
        }
        
        
    }
}
