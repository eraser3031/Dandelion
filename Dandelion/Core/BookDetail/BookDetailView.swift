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
    @StateObject var vm: BookDetailViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var isInputActive: Bool
    @State private var sheetCase: BookDetailCase = .info
    @State private var review = ""
    @State private var showRatingSheet = true
    @State private var score = 0
    @State private var showManageSheet = false
    @State private var isEdit = false
    @State private var deleteBookDialog = false
    @Namespace var id
    
    init(book: Book) {
        self._vm = StateObject(wrappedValue: BookDetailViewModel(book: book))
    }
    
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
                        if isEdit {
                            Button {
                                withAnimation(.spring()) {
                                    isEdit = false
                                }
                            } label: {
                                Text("Done")
                                    .frame(height: 34)
                            }
                            .buttonStyle(.plain)
                        } else {
                            
                            if sheetCase == .bookmark {
                                Button {
                                    showManageSheet = true
                                } label: {
                                    Image(systemName: "plus")
                                }
                                .buttonStyle(CircledButtonStyle())
                            }
                            
                            Menu {
                                if sheetCase == .info {
                                    Button {
                                        deleteBookDialog = true
                                        print(deleteBookDialog)
                                    } label: {
                                        Label("Delete Book", systemImage: "trash")
                                    }
                                } else {
                                    Button {
                                        withAnimation(.spring()){
                                            isEdit = true
                                        }
                                    } label: {
                                        Label("Edit Bookmarks", systemImage: "pencil")
                                    }
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .frame(width: 34, height: 34)
                                    .foregroundColor(.theme.primary)
                                    .font(.theme.plainButton)
                                    .background(
                                        Circle()
                                            .fill(Color.theme.groupedBackground)
                                    )
                            }
                            
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
            
            if sheetCase == .info {
                BookInfoView(vm: vm, id: id, review: $review, showRatingSheet: $showRatingSheet, score: $score)
                    .padding(.horizontal, 30)
                    .transition(
                        .asymmetric(insertion: .move(edge: .leading),
                                    removal: .move(edge: .trailing)
                                   ).combined(with: .opacity)
                    )
            } else {
                BookMarkView(vm: vm, showManageSheet: $showManageSheet, isEdit: $isEdit)
                    .transition(
                        .asymmetric(insertion: .move(edge: .trailing),
                                    removal: .move(edge: .leading))
                        .combined(with: .opacity)
                    )
            }
        }
        .padding(.top, 8)
        .blur(radius: showRatingSheet ? 20 : 0)
        .overlay {
            ZStack {
                if showRatingSheet {
                    Color.theme.primary.opacity(0.2)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isInputActive = false
                                showRatingSheet = false
                                vm.updateRating(score: score, review: review)
                            }
                        }
                }
                ZStack {
                    if showRatingSheet {
                        RatingSheet
                    }
                }
            }
        }
        .confirmationDialog("Are you sure?", isPresented: $deleteBookDialog, titleVisibility: .visible) {
            Button("Delete Book", role: .destructive) {
                dismiss()
                vm.removeBook()
            }
            Button("Cancel", role: .cancel) {
                deleteBookDialog = false
            }
        }
        .onAppear{
            showRatingSheet = false
            review = vm.rating.review ?? ""
            score = Int(vm.rating.score)
        }
        .task {
            if vm.book.shape == nil {
                await vm.fetchBookShape()
            }
        }
    }
    
    private var RatingSheet: some View {
        VStack(spacing: 20) {
            
            RatingIndicator(score: score)
                .matchedGeometryEffect(id: "text", in: id)
            
            RatingSlider(value: $score, showingRatingSheet: showRatingSheet, id: id)
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.theme.groupedBackground)
                        .matchedGeometryEffect(id: "ratingBackground", in: id)
                )
            
            Hdivider
            
            ReviewTextField(text: $review, id: id)
                .focused($isInputActive)
                .padding(.vertical, 30)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.theme.groupedBackground)
                        .matchedGeometryEffect(id: "ibackground", in: id)
                )
        }
        .padding(35)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color.theme.background)
                .matchedGeometryEffect(id: "background", in: id)
        )
        .padding(30)
    }
    
    private var Hdivider: some View {
        Rectangle()
            .fill(Color.theme.labelBackground)
            .frame(height: 1)
    }
}
