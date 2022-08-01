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
    
    @Environment(\.dismiss) var dismiss
    @State private var sheetCase: BookDetailCase = .info
    var book: Book
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 26) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.theme.title2)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    Text("Info")
                        .font(.theme.sheetTitle)
                        .foregroundColor(sheetCase == .info ? .theme.primary : .theme.labelBackground)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                sheetCase = .info
                            }
                        }
                    Text("Bookmark")
                        .font(.theme.sheetTitle)
                        .foregroundColor(sheetCase == .bookmark ? .theme.primary : .theme.labelBackground)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                sheetCase = .bookmark
                            }
                        }
                    Spacer()
                    
                    HStack(spacing: 16) {
                        if sheetCase == .bookmark {
                            Button {
                                print("hi")
                            } label: {
                                Image(systemName: "plus")
                            }
                            .buttonStyle(CircledButtonStyle())
                        }
                        
                        Button {
                            print("hi")
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                        .buttonStyle(CircledButtonStyle())
                    }
                }
            }
            .padding(.horizontal, 30)
            
            if sheetCase == .info {
                BookInfoView(book: book)
                    .padding(.horizontal, 30)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
            } else {
                BookMarkView(book: book)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }
        }
        .padding(.top, 8)
    }
}
