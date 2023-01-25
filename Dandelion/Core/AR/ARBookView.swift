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

@MainActor
extension ARViewContainer.Coordinator {
    func generateSnapshotAsync<Content: View>(content: Content) async -> CGImage? {
        let renderer = ImageRenderer(content: content)
        renderer.scale = UIScreen.main.scale
        return renderer.cgImage
    }
    
    func createBookmarkView(bookmark: Bookmark) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(bookmark.page)p")
                .font(.theme.footnote)
            
            Text(bookmark.note ?? "")
                .font(.theme.regularSerif)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding(20)
        .frame(width: 360, height: 120)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
        )
    }
}

class CustomARView: ARView {
    var books: [Book] = []
    var newReferenceImages:Set<ARReferenceImage> = Set<ARReferenceImage>()
    
    init(frame frameRect: CGRect, books: [Book]) {
        self.books = books
        super.init(frame: .zero)
        Task { [weak self] in
            do {
                let covers = try await fetchBookCovers()
                for (book, cover) in covers {
                    let bookWidth = max(CGFloat(book.shape?.width ?? 0) / 1000, 0.1)
                    let arImage = ARReferenceImage(cover.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: bookWidth)
                    arImage.name = book.id?.uuidString ?? ""
                    self?.newReferenceImages.insert(arImage)
                    self?.resetTracking()
                }
            } catch {
                print("Fetch ReferenceImage Failed")
            }
        }
    }
    
    required init(frame frameRect: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError()
    }

    private func fetchBookCovers() async throws -> [Book: UIImage] {
        var images: [Book: UIImage] = [:]
        try await withThrowingTaskGroup(of: (Book, UIImage?).self) { group in
            for book in books {
                guard let url = book.coverURL else { continue }
                group.addTask {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    return (book, UIImage(data: data))
                }
            }

            for try await (book, image) in group {
                guard let image = image else { continue }
                images[book] = image
            }
        }

        return images
    }
    
    public func resetTracking() {
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = newReferenceImages;
        configuration.maximumNumberOfTrackedImages = 1;
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}
