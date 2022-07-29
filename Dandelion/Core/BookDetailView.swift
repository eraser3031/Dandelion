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
                        .foregroundColor(sheetCase == .info ? .theme.primary : .theme.labelBackground)
                        .onTapGesture {
                            sheetCase = .info
                        }
                    Text("Bookmark")
                        .font(.theme.sheetTitle)
                        .foregroundColor(sheetCase == .bookmark ? .theme.primary : .theme.labelBackground)
                        .onTapGesture {
                            sheetCase = .bookmark
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
                BookInfoView()
                    .padding(.horizontal, 30)
            } else {
                BookMarkView()
            }
        }
        .padding(.top, 8)
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView()
    }
}
