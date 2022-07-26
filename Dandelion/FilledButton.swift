//
//  FilledButton.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI

struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.theme.filledButton)
            .foregroundColor(.theme.background)
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
            )
        
    }
}

struct FilledButton_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            print("hi")
        } label: {
            Label("Add Book", systemImage: "plus")
        }
        .buttonStyle(FilledButtonStyle())

    }
}
