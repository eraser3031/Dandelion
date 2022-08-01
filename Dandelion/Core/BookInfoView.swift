//
//  BookInfoView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI
import Kingfisher

struct BookInfoView: View {
    
    var book: Book
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    KFImage(book.coverURL)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150) //
                    VStack(spacing: 4) {
                        Text(book.title ?? "")
                            .font(.theme.headline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        Text(book.author ?? "")
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
                    VStack(spacing: 20) {
                        HStack(spacing: 22) {
                            ForEach(-2..<3) { i in
                                Image.star
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.theme.quaternary)
                                    .offset(y: CGFloat(abs(i)) == 1 ? 20 : CGFloat(abs(i)) == 2 ? 66 : 0)
                                    .offset(x: CGFloat(abs(i)) == 1 ? 12*CGFloat(i) : 0)
                            }
                        }
                        VStack(spacing: 6) {
                            Text("rating")
                                .font(.theme.subHeadline)
                            Text("3 / 5")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                        }
                        Text("“ Work hard in silence, let\nyour success be the noise ”")
                            .font(.theme.regularSerifItalic)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.theme.subGroupedBackground)
                )
                
                HStack {
                    BookInfoLabel(title: "Date", mainLabel: "2012", subLabel: "11.23")
                        .overlay(alignment: .trailing) {
                            divider
                        }
                    
                    BookInfoLabel(title: "Length", mainLabel: "132", subLabel: "pages")
                        .overlay(alignment: .trailing) {
                            divider
                        }
                    
                    BookInfoLabel(title: "Price", mainLabel: "11.2", subLabel: "dollar")
                    
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
            }
        }
    }
    
    private var divider: some View {
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
                    .font(.theme.headlineLabel)
                Text(subLabel)
                    .font(.theme.footnote)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
