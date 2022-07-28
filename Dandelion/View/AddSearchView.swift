//
//  AddSearchView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI

struct AddSearchView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(spacing: 26) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.theme.title2)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.theme.headline)
                }
                .buttonStyle(.plain)
            }
            
            VStack(spacing: 10) {
                Text("Search")
                    .font(.theme.sheetTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                SearchBar(text: $searchText)
            }
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(0..<3) { i in
                        SearchBookCellView(name: "SWNA", author: "Frank Ocean")
                    }
                }
            }
        }
        .padding(.top, 8)
        .padding(.horizontal, 30)
    }
}

struct SearchBookCellView: View {
    
    var thumbnail: Data? = nil
    var name: String
    var author: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image("Book4")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .font(.theme.subHeadline)
                Text(author)
                    .font(.theme.footnote)
                    .foregroundColor(.theme.quaternary)
            }
            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.theme.groupedBackground)
        )
    }
}

struct AddSearchView_Previews: PreviewProvider {
    static var previews: some View {
        AddSearchView()
    }
}
