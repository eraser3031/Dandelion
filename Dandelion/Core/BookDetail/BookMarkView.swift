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
    @State private var width: CGFloat = 0
    @State private var deleteBookmarkDiaLog: Bookmark?
    
    let trailingGapPer: CGFloat = 0.132
    let leadingGapPer: CGFloat = 0.357
    var pageGapPer: CGFloat {
        1 - trailingGapPer - leadingGapPer
    }
    
    var body: some View {
        let diaLog = Binding(
                    get: { self.deleteBookmarkDiaLog != nil },
                    set: {
                        if $0 == false {
                            deleteBookmarkDiaLog = nil
                        }
                    }
                )
        
        return ZStack(alignment: .leading) {
            if vm.bookmarks.count != 0 {
                Image.bookLeft
                    .resizable()
                    .scaledToFit()
                    .modifier(SizeModifier())
                    .onPreferenceChange(SizePreferenceKey.self) { size in
                        width = size.width
                    }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        ForEach(vm.bookmarks) { bookmark in
                            HStack(spacing: 0) {
                                
                                Color.clear
                                    .frame(width: width + 20)
                                    .overlay(alignment: .trailing) {
                                        HStack(spacing: 0) {
                                            Rectangle()
                                                .fill(.black)
                                                .frame(width: calPageIndicatorWidth(bookmark.page), height: 1)
                                            Rectangle()
                                                .fill(Color.theme.primary)
                                                .frame(width: 20, height: 1)
                                        }
                                        .clipShape(Capsule())
                                        .overlay(alignment: .leading) {
                                            Circle()
                                                .fill(.black)
                                                .frame(width: 4, height: 4)
                                                .offset(x: -2)
                                                
                                        }
                                    }
                                
                                ZStack(alignment: .topTrailing) {
                                    Cell(bookmark)
                                        .opacity(isEdit ? 0.5 : 1)
                                    
                                    if isEdit {
                                        Button {
                                            withAnimation(.spring()) {
                                                deleteBookmarkDiaLog = bookmark
                                            }
                                        } label: {
                                            Image(systemName: "xmark")
                                                .font(.theme.caption)
                                        }
                                        .buttonStyle(EditCircledButtonStyle())
                                        .padding(10)
                                        .confirmationDialog("Are you sure?", isPresented: diaLog, titleVisibility: .visible) {
                                            Button("Delete Bookmark", role: .destructive) {
                                                withAnimation(.spring()) {
                                                    vm.removeBookmark(bookmark)
                                                }
                                            }
                                            Button("Cancel", role: .cancel) {
                                                deleteBookmarkDiaLog = nil
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.trailing, 20)
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
    
    private func calPageIndicatorWidth(_ page: Int32) -> CGFloat {
        let startWidth = width * (1 - leadingGapPer)
        let pageWidth = CGFloat(page) * width * pageGapPer
        let bookPages = CGFloat(vm.book.shape?.pages ?? 0)
        return startWidth - pageWidth / bookPages
    }
}
