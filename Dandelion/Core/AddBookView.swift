//
//  AddBookView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI
import Kingfisher

enum AddCase: String {
    case search
    case barcode
    case camera
}

struct AddBookView: View {
    
    @State private var selectedItems: [Item] = []
    
    var addCase: AddCase
    var body: some View {
        ZStack(alignment: .top) {
            Color.theme.primary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack {
                    Color.theme.background
                        .cornerRadius(32, corners: [.bottomLeft, .bottomRight])
                        .ignoresSafeArea(.container)
                    
                    
                    switch addCase {
                    case .search:
                        AddSearchView(selectedItem: $selectedItems)
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
                        ForEach(selectedItems) { i in
                            ZStack(alignment: .bottomTrailing) {
                                KFImage(URL(string: i.cover))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .overlay(
                                        Color.black.opacity(0.2)
                                    )
                                    .cornerRadius(4)
                                
                                Button {
                                    withAnimation(.spring()) {
                                        selectedItems.removeAll(where: {$0.id == i.id})
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .buttonStyle(SheetDismissButtonStyle())
                                .padding(4)

                            }
                        }
                    }
                    .padding(.vertical, selectedItems.isEmpty ? 0 : 20)
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
