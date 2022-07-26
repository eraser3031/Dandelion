//
//  BookDetailView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI

enum BookDetailCase: String {
    case info
    case bookmark
}

struct BookDetailView: View {
    
    @State private var sheetCase: BookDetailCase = .info
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 26) {
                HStack {
                    Button {
                        print("hi")
                    } label: {
                        Image(systemName: "xmark")
                            .font(.theme.title2)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    Text("Info")
                        .font(.theme.sheetTitle)
                    Text("Bookmark")
                        .font(.theme.sheetTitle)
                        .foregroundColor(.theme.labelBackground)
                    Spacer()
                    
                    Button {
                        print("hi")
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .buttonStyle(CircledButtonStyle())
                }
            }
            
            VStack(spacing: 16) {
                Image("Book3")
                VStack(spacing: 4) {
                    Text("Pride and Prejudice")
                        .font(.theme.filledButton)
                    Text("Jane Austen")
                        .font(.theme.footnote)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .strokeBorder(Color.theme.groupedBackground)
            )
            
            ZStack {
                VStack(spacing: 20) {
                    VStack(spacing: 6) {
                        Text("rating")
                            .font(.theme.subHeadline)
                        Text("3 / 5")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                    }
                    Text("“ Work hard in silence, let\nyour success be the noise ”")
                        .font(.theme.regularSerifItalic)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color.theme.subGroupedBackground)
            )
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 8)
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView()
    }
}
