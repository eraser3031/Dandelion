//
//  AddSearchView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI
import Kingfisher

struct AddSearchView: View {
    @StateObject private var vm = AddSearchViewModel()
    @FocusState private var focus: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 26) {
            Group {
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
                    
                    SearchBar(text: $vm.searchText)
                        .focused($focus, equals: true)
                        .onSubmit {
                            Task {
                                await vm.search()
                            }
                        }
                        .submitLabel(.search)
                }
            }
            .padding(.horizontal, 30)
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(vm.searchedItems, id: \.title) { item in
                        SearchBookCellView(thumbnail: URL(string: item.cover),
                                           name: item.title,
                                           author: item.author)
                    }
                }
                .padding(.horizontal, 30)
            }
            
        }
        .padding(.top, 8)
        .onAppear{
            focus = true
        }
    }
}

struct SearchBookCellView: View {
    
    var thumbnail: URL?
    var name: String
    var author: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            KFImage(thumbnail)
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
