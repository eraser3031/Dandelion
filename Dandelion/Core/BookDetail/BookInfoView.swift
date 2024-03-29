//
//  BookInfoView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI
import Kingfisher

struct BookInfoView: View {
    
    @ObservedObject var vm: BookDetailViewModel
    var id: Namespace.ID
    @Binding var review: String
    @Binding var showRatingSheet: Bool
    @Binding var score: Int
    
    @State private var ratingHeight: CGFloat = 0
    
    var year: String {
        "\((vm.book.publishedDate ?? Date()).year)"
    }
    
    var monthWithDay: String {
        "\((vm.book.publishedDate ?? Date()).month).\((vm.book.publishedDate ?? Date()).day)"
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    KFImage(vm.book.coverURL)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .overlay {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .stroke(Color.theme.labelBackground, lineWidth: 0.5)
                        }
                    
                    VStack(spacing: 4) {
                        Text(vm.book.title ?? "")
                            .font(.theme.headline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        Text(vm.book.author ?? "")
                            .font(.theme.footnote)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .strokeBorder(Color.theme.groupedBackground)
                )
                
                ZStack {
                    Spacer()
                        .frame(height: ratingHeight)
                    
                    if !showRatingSheet {
                        innerRating
                    }
                }
                
                HStack(alignment: .top, spacing: 0) {
                    BookInfoLabel(title: "Date", mainLabel: year, subLabel: monthWithDay)
                        .overlay(alignment: .trailing) {
                            Vdivider
                        }
                    
                    BookInfoLabel(title: "Publisher", mainLabel: vm.book.publisher ?? "", subLabel: "")
                        .overlay(alignment: .trailing) {
                            Vdivider
                        }
                    
                    BookInfoLabel(title: "Genre", mainLabel: vm.book.genre ?? "", subLabel: "")
                    
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    private var innerRating: some View {
        VStack(spacing: 20) {
            
            RatingSlider(value: $score, showingRatingSheet: showRatingSheet, id: id)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.theme.subGroupedBackground)
                        .matchedGeometryEffect(id: "ratingBackground", in: id)
                )
                
            RatingIndicator(score: score)
                .matchedGeometryEffect(id: "text", in: id)
            
            ReviewTextField(text: $review, id: id)
                .disabled(true)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.theme.subGroupedBackground)
                        .matchedGeometryEffect(id: "ibackground", in: id)
                )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring()) {
                showRatingSheet.toggle()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color.theme.subGroupedBackground)
                .matchedGeometryEffect(id: "background", in: id)
                .modifier(SizeModifier())
                .onPreferenceChange(SizePreferenceKey.self) { size in
                    ratingHeight = size.height
                }
        )
    }
    
    private var Vdivider: some View {
        Rectangle()
            .fill(Color.theme.labelBackground)
            .frame(width: 1)
    }
}

struct BookInfoLabel: View {
    var title: String
    var mainLabel: String
    var subLabel: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.theme.footnote)
                .foregroundColor(.theme.tertiary)
            VStack(spacing: 0) {
                Text(mainLabel)
                    .font(.theme.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                Text(subLabel)
                    .font(.theme.footnote)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
