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
    
    var url: String
    
    var body: some View {
        ARViewContainer(url: url)
            .ignoresSafeArea()
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    var url: String
    let arView: CustomARView
    
    init(url: String) {
        self.url = url
        self.arView = CustomARView(frame: .zero, url: url)
    }
    
    func makeUIView(context: Context) -> CustomARView {
//        var referenceImages = Set<ARReferenceImage>()
//        guard let cgImage = image.cgImage else { fatalError("이러면 안되는데..") }
//        let imageWidth = CGFloat(cgImage.width)
//        let customARReferenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: imageWidth)
//        customARReferenceImage.name = "MyCustomARImage"
//        referenceImages.insert(customARReferenceImage)
        
        arView.session.delegate = context.coordinator
        
        let configuration = ARImageTrackingConfiguration()
        configuration.isAutoFocusEnabled = true
        configuration.maximumNumberOfTrackedImages = 1
        
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        } else {
            print("People Segmentation not enabled.")
        }
        
        arView.session.run(configuration)
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) { }
    
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
            
            let width = Float(imageAnchor.referenceImage.physicalSize.width * 1.03)
            let height = Float(imageAnchor.referenceImage.physicalSize.height * 1.03)
            let simpleMaterial = SimpleMaterial(color: .white, isMetallic: false)
            let entity = ModelEntity(mesh: .generatePlane(width: width, depth: height, cornerRadius: 0.3), materials: [simpleMaterial])
            
            let anchor = AnchorEntity(anchor: imageAnchor)
            anchor.addChild(entity)
            parent.arView.scene.addAnchor(anchor)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

class CustomARView: ARView {
    
    var url: String
    var newReferenceImages:Set<ARReferenceImage> = Set<ARReferenceImage>()
    
    init(frame frameRect: CGRect, url: String) {
        self.url = url
        super.init(frame: .zero)
        self.loadImageFrom(url: URL(string: url)!) { (result) in
            let arImage = ARReferenceImage(result.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.1)
            arImage.name = "REFERENCE_IMAGE_NAME"
            self.newReferenceImages.insert(arImage)
            self.resetTracking()
        }
    }
    
    required init(frame frameRect: CGRect) {
        self.url = ""
        super.init(frame: .zero)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError()
    }
    
    func loadImageFrom(url: URL, completionHandler: @escaping(UIImage)->()) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        print("LOADED ASSET");
                        completionHandler(image);
                    }
                }
            }
        }
    }
    
    public func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = newReferenceImages;
        configuration.maximumNumberOfTrackedImages = 1;
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}
