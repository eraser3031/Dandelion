//
//  TestARView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/17.
//

import ARKit
import RealityKit
import SwiftUI

struct TestARView: View {
    var body: some View {
        ARViewContainer()
            .ignoresSafeArea()
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    let arView = ARView(frame: .zero)
    
    func makeUIView(context: Context) -> ARView {
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) { }
    
    class Coordinator: NSObject, ARSessionDelegate {
        
        var parent: ARViewContainer
        
        init(parent: ARViewContainer) {
            self.parent = parent
        }
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            guard let imageAnchor = anchors[0] as? ARImageAnchor else {
                print("Problems loading anchor.")
                return
            }
            
            // Assigns video to be overlaid
            guard let path = Bundle.main.path(forResource: "iphonevideo", ofType: "mp4") else {
                print("Unable to find video file.")
                return
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}
