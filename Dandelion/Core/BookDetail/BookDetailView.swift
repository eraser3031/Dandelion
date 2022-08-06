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
    @State private var sheetCase: BookDetailCase = .info
    @State private var text = ""
    @State private var showRatingSheet = false
    @State private var rating = 0
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
                BookInfoView(vm: vm, id: id, text: $text, showRatingSheet: $showRatingSheet, rating: $rating)
                    .padding(.horizontal, 30)
                    .transition(
                        .asymmetric(insertion: .move(edge: .leading),
                                    removal: .move(edge: .trailing)
                                   ).combined(with: .opacity)
                    )
            } else {
                BookMarkView(vm: vm)
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
                                showRatingSheet = false
                            }
                        }
                    
                    RatingSheet
                }
            }
        }
    }
    
    private var RatingSheet: some View {
        VStack(spacing: 20) {
            
            RatingIndicator()
                .matchedGeometryEffect(id: "text", in: id)
            
            RatingSlider(value: $rating, showingRatingSheet: showRatingSheet, id: id)
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.theme.groupedBackground)
                        .matchedGeometryEffect(id: "ratingBackground", in: id)
                )
            
            Hdivider
            
            ReviewTextField(text: $text, id: id)
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
