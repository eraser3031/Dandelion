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
            .font(.theme.headline)
            .foregroundColor(.theme.background)
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
            )
        
    }
}

struct CircledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 34, height: 34)
            .foregroundColor(.theme.primary)
            .font(.theme.plainButton)
            .background(
                Circle()
                    .fill(Color.theme.groupedBackground)
            )
    }
}

struct EditCircledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 25, height: 25)
            .foregroundColor(.theme.primary)
            .font(.theme.plainButton)
            .background(
                Circle()
                    .fill(Color.theme.labelBackground)
            )
    }
}

struct SheetDismissButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 22, height: 22)
            .foregroundColor(.theme.secondary)
            .font(.theme.footnote)
            .background(
                Circle()
                    .fill(Color.theme.groupedBackground)
            )
    }
}

struct FilledButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
            Button {
                print("hi")
            } label: {
                Label("Add Book", systemImage: "plus")
            }
            .buttonStyle(FilledButtonStyle())
            
            Button {
                print("hi")
            } label: {
                Image(systemName: "ellipsis")
            }
            .buttonStyle(CircledButtonStyle())
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
