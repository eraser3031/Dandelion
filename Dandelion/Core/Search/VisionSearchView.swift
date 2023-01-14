//
//  VisionSearchView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/26.
//

import simd
import ARKit
import RealityKit
import SwiftUI

struct VisionSearchARViewContainer: UIViewRepresentable {
    
    @Binding var tipPoint: CGPoint
    
    func makeUIView(context: Context) -> VisionSearchARView {
        let view = VisionSearchARView(frame: .zero, tipPoint: $tipPoint)
        return view
    }
    
    func updateUIView(_ uiView: VisionSearchARView, context: Context) {}
}

class VisionSearchARView: ARView, ARSessionDelegate {
    
    let handPoseRequest = VNDetectHumanHandPoseRequest()
    @Binding var tipPoint: CGPoint
    private var frameRateRegulator = FrameRateRegulator()
    var canRequestbyFrame: Bool {
        frameRateRegulator.canContinue()
    }
    
    required init(frame frameRect: CGRect) {
        fatalError("init")
    }
    
    required init(frame frameRect: CGRect, tipPoint: Binding<CGPoint>) {
        self._tipPoint = tipPoint
        super.init(frame: frameRect)
        setupHandPoseRequest()
        setupConfig()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init")
    }
    
    func setupHandPoseRequest() {
        handPoseRequest.maximumHandCount = 1
    }
    
    func setupConfig() {
        let config = ARWorldTrackingConfiguration()
//        let frameSemantics: ARConfiguration.FrameSemantics = .personSegmentationWithDepth
//
//        if ARWorldTrackingConfiguration.supportsFrameSemantics(frameSemantics) {
//            config.frameSemantics.insert(frameSemantics)
//        }
        session.delegate = self
        session.run(config)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if canRequestbyFrame {
            let handler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage, orientation: .right, options: [:])
            do {
                try handler.perform([handPoseRequest])
                guard let observation = handPoseRequest.results?.first else { return }
                let point = try observation.recognizedPoint(.indexTip)
                
                guard point.confidence > 0.6 else { return }
                self.tipPoint = CGPoint(x: point.location.x, y: 1 - point.location.y)
//                getWorldPosition(screenPosition: self.tipPoint, depth: 0)
            } catch {
                print(error)
            }
        }
    }
    
    func getWorldPosition(screenPosition: CGPoint, depth: Float) -> simd_float3? {
        guard let rayResult = ray(through: screenPosition) else { return nil }
        let worldOffset = rayResult.direction * depth
        let worldPosition = rayResult.origin + worldOffset
        return worldPosition
    }
}

public class FrameRateRegulator {
    public enum RequestRate: Int {
        case everyFrame = 1
        case half = 2
        case quarter = 4
    }
    
    ///The frequency that the Vision request for detecting hands will be performed.
    ///
    ///Running the request every frame may decrease performance.
    ///Can be reduced to increase performance at the cost of choppy tracking.
    ///Set to half to run every other frame. Set to quarter to run every 1 out of 4 frames.
    public var requestRate: RequestRate = .half
    
    private var frameInt = 1
    
    fileprivate func canContinue() -> Bool {
        if frameInt == self.requestRate.rawValue {
            frameInt = 1
            return true
            
        } else {
            frameInt += 1
            return false
        }
    }
}
