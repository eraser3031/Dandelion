//
//  AddSearchView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/26.
//

import SwiftUI
import Kingfisher

struct AddSearchView: View {
    @Binding var selectedItem: [Item]
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
                        vm.addBooks(items: selectedItem)
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
            
            if vm.searchedItems.isEmpty, !vm.searchText.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    
                    Image.seed
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                    
                    Text("No results..")
                        .font(.theme.subHeadline)
                    
                    Spacer()
                }
                .foregroundColor(.theme.tertiary)
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(vm.searchedItems, id: \.title) { item in
                            SearchBookCellView(selectedItem: $selectedItem, item: item)
                        }
                    }
                    .padding(.horizontal, 30)
                }
            }
        }
        .padding(.top, 8)
        .onAppear{
            focus = true
        }
    }
}

struct SearchBookCellView: View {
    
    @Binding var selectedItem: [Item]
    
    var item: Item
    
    var isSelected: Bool {
        selectedItem.contains(where: {$0.id == item.id })
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            KFImage(URL(string: item.cover))
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            VStack(alignment: .leading, spacing: 0) {
                Text(item.title)
                    .font(.theme.subHeadline)
                Text(item.author)
                    .font(.theme.footnote)
                    .foregroundColor(.theme.quaternary)
            }
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.theme.title2)
                    .frame(maxHeight: .infinity)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(isSelected ? Color.theme.primary : Color.theme.groupedBackground)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring()) {
                if selectedItem.contains(where: {$0.id == item.id}) {
                    withAnimation(.spring()) {
                        selectedItem.removeAll(where: {$0.id == item.id})
                    }
                } else {
                    withAnimation(.spring()) {
                        selectedItem.append(item)
                    }
                }
            }
        }
    }
}
