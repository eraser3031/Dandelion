//
//  BookMarkView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI

struct BookMarkView: View {
    
    @ObservedObject var vm: BookDetailViewModel
    @Binding var showManageSheet: Bool
    @Binding var isEdit: Bool
    @State private var item: Bookmark?
    
    var body: some View {
        ZStack {
            if vm.bookmarks.count != 0 {
                HStack(spacing: 20) {
                    Image.bookLeft
                        .resizable()
                        .scaledToFit()
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            ForEach(vm.bookmarks) { bookmark in
                                ZStack(alignment: .topTrailing) {
                                    Cell(bookmark)
                                    
                                    if isEdit {
                                        Button {
                                            withAnimation(.spring()) {
                                                vm.removeBookmark(bookmark)
                                            }
                                        } label: {
                                            Image(systemName: "xmark")
                                        }
                                        .buttonStyle(CircledButtonStyle())
                                        .padding(10)
                                    }
                                }
                            }
                        }
                        .padding(.trailing, 20)
                    }
                }
            } else {
                VStack(spacing: 30) {
                    VStack(spacing: 0) {
                        Image.bookHorizontal
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                        
                        Text("No results..")
                            .font(.theme.subHeadline)
                    }
                    .foregroundColor(.theme.tertiary)
                    
                    Button {
                        showManageSheet = true
                    } label: {
                        Label("Add BookMark", systemImage: "plus")
                    }
                    .buttonStyle(FilledButtonStyle())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sheet(isPresented: $showManageSheet) {
            ManageBookmarkView(vm: vm)
        }
        .sheet(item: $item) { item in
            ManageBookmarkView(vm: vm, bookmark: item)
        }
    }
    
    private func Cell(_ bookmark: Bookmark) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(bookmark.page)p")
                .font(.theme.footnote)
            Text(bookmark.note ?? "")
                .font(.theme.regularSerif)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.regularMaterial)
        )
        .onTapGesture {
            item = bookmark
        }
    }
}
