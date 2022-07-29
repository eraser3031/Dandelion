//
//  AddBookView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI

enum AddCase: String {
    case search
    case barcode
    case camera
}

struct AddBookView: View {
    @State private var selectedBooks: [String] = ["Sasdf", "asdf","as","a","asd"]
    var addCase: AddCase
    var body: some View {
        ZStack(alignment: .top) {
            Color.theme.primary
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    Color.theme.background
                        .cornerRadius(32, corners: [.bottomLeft, .bottomRight])
                        .ignoresSafeArea(.container)
                    
                    
                    switch addCase {
                    case .search:
                        AddSearchView()
                    case .barcode:
                        EmptyView()
                    case .camera:
                        EmptyView()
                    }
                }
                
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        Spacer()
                            .frame(width: 0)
                        ForEach(selectedBooks.indices, id: \.self) { i in
                            ZStack(alignment: .bottomTrailing) {
                                Image("Book\(i+1)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .overlay(
                                        Color.black.opacity(0.2)
                                    )
                                    .cornerRadius(4)
                                
                                Button {
                                    print("hihi")
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .buttonStyle(SheetDismissButtonStyle())
                                .padding(4)

                            }
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
            .frame(maxHeight: .infinity)
            .ignoresSafeArea(.keyboard)
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView(addCase: .search)
    }
}
