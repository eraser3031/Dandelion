//
//  TestARView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/17.
//

import ARKit
import RealityKit
import SwiftUI

struct ARBookView: View {
    @Environment(\.dismiss) var dismiss
    var books: [Book]
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            ARViewContainer(books: books)
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
    var books: [Book]
    let arView: CustomARView
    
    init(books: [Book]) {
        self.books = books
        self.arView = CustomARView(frame: .zero, books: books)
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
            if let imageAnchor = anchors[0] as? ARImageAnchor {
                let anchor = AnchorEntity(anchor: imageAnchor)
                parent.arView.scene.addAnchor(anchor)
                guard let referenceBook = parent.books.first(where: { imageAnchor.referenceImage.name == $0.id?.uuidString ?? "" }) else { return print("why...") }
                
                Task { @MainActor in
                    let bookmarksEntitiy = await displayBookmarks(book: referenceBook)
                    if let bookmarksEntitiy = bookmarksEntitiy {
                        anchor.addChild(bookmarksEntitiy)
                    }
                }
            }
        }
        
        @MainActor
        func displayBookmarks(book: Book) async -> Entity? {
            // ? = 책 두께 * 현재페이지 / 전체페이지
            let bookmarksEntity = Entity()
            
            guard let bookShape = book.shape,
                  let bookmark = book.bookmarks?.allObjects as? [Bookmark] else { return nil }
            
            for (i, bookmark) in bookmark.enumerated() {
                let y = -Float(bookShape.depth) * Float(bookmark.page) / Float(bookShape.pages) / 1000.0
                let x = Float(bookShape.width) / 2 / 1000.0 + 0.03 + 0.01
                
                let cgImage = await generateSnapshotAsync(content: createBookmarkView(bookmark: bookmark))
                var mat = UnlitMaterial()
                let textureResource = try? TextureResource.generate(from: cgImage!, options: .init(semantic: .color))
                mat.color = .init(tint: .white.withAlphaComponent(0.9999), texture: .init(.init(textureResource!)))
                let entity = ModelEntity(mesh: .generatePlane(width: 0.06, depth: 0.02), materials: [mat])
                
                entity.move(to: .init(translation: .init(x, y, (Float(i) * 0.02) + 0.02 - Float(bookShape.height) / 2000.0)), relativeTo: nil)
                bookmarksEntity.addChild(entity)
            }

            return bookmarksEntity
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
