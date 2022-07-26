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
