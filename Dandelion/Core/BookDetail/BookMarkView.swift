//
//  BookMarkView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI

struct BookMarkView: View {
    
    @State private var bookmarks: [String] = [""]
    @State private var showManageSheet = false
    @ObservedObject var vm: BookDetailViewModel
    
    var body: some View {
        ZStack {
            if bookmarks.count != 0 {
                HStack(spacing: 20) {
                    Image.bookLeft
                        .resizable()
                        .scaledToFit()
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            ForEach(0..<10) { i in
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("150p")
                                        .font(.theme.footnote)
                                    Text("Better to arrive late than not to come at allTo get something over with because it is inevitable")
                                        .font(.theme.regularSerif)
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(.regularMaterial)
                                )
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
                        print("hi")
                    } label: {
                        Label("Add BookMark", systemImage: "plus")
                    }
                    .buttonStyle(FilledButtonStyle())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sheet(isPresented: $showManageSheet) {
            ManageBookmarkView()
        }
    }
}
