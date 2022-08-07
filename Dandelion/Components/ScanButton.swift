//
//  ScanButton.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/07.
//

import SwiftUI

struct ScanButton: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UIButton {
        let textFromCamera = UIAction.captureTextFromCamera(
          responder: context.coordinator,
          identifier: nil)
        let button = UIButton(primaryAction: textFromCamera)
        button.tintColor = UIColor(named: "primary")
        return button
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: UIResponder, UIKeyInput {
        let parent: ScanButton
        init(_ parent: ScanButton) { self.parent = parent }
        
        var hasText = false
        func insertText(_ text: String) {
            parent.text = text
        }
        func deleteBackward() { }
    }
}


//struct ScanButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ScanButton()
//    }
//}
