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
    var bookmarks: [Bookmark]
    var bookShape: BookShape
    var url: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            ARViewContainer(bookmarks: bookmarks, bookShape: bookShape, url: url)
                .edgesIgnoringSafeArea(.all)
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }
            .buttonStyle(CircledButtonStyle())

        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    var bookmarks: [Bookmark]
    var bookShape: BookShape
    var url: String
    let arView: CustomARView
    
    init(bookmarks: [Bookmark], bookShape: BookShape, url: String) {
        self.bookmarks = bookmarks
        self.bookShape = bookShape
        self.url = url
        self.arView = CustomARView(frame: .zero, bookmarks: bookmarks, bookShape: bookShape, url: url)
    }
    
    func makeUIView(context: Context) -> CustomARView {        
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
            let bookmarkEntities = displayBookmarks()
            bookmarkEntities.forEach { entity in
                anchor.addChild(entity)
            }
        }
        
        func displayBookmarks() -> [ModelEntity] {
            // ? = 책 두께 * 현재페이지 / 전체페이지
            var entities: [ModelEntity] = []
            for (i, bookmark) in parent.bookmarks.enumerated() {
                let y = CGFloat(parent.bookShape.depth) * CGFloat(bookmark.page) / CGFloat(parent.bookShape.pages)
                let x = CGFloat(parent.bookShape.width) / 2
                
                let mesh = MeshResource.generatePlane(width: 0.01, height: 0.01)
                let material = UnlitMaterial.init(color: .blue)
                let entity = ModelEntity(mesh: mesh, materials: [material])
                
//                entity.position = [x,y,CGFloat(i)/10]
                entities.append(entity)
            }
            
            return entities
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

class CustomARView: ARView {
    
    var bookmarks: [Bookmark]
    var bookShape: BookShape
    var url: String
    var newReferenceImages:Set<ARReferenceImage> = Set<ARReferenceImage>()
    
    init(frame frameRect: CGRect, bookmarks:[Bookmark], bookShape: BookShape, url: String) {
        self.bookmarks = bookmarks
        self.bookShape = bookShape
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
        self.bookShape = BookShape()
        self.bookmarks = []
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
