//
//  ContentView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/23.
//

import SwiftUI

struct BookListView: View {
    
    @StateObject private var vm = BookListViewModel()
    @State private var searchText: String = ""
    @State private var showAddSheet = false
    @State private var showAddSearchView = false
    
    private var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100), spacing: 12, alignment: .bottom)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Group {
                Image.logo
                    .resizable()
                    .foregroundColor(.theme.dandelion)
                    .frame(width: 32, height: 32)
                
                SearchBar(text: $searchText)
                
                HStack(alignment: .center, spacing: 16) {
                    Text("132")
                        .font(.theme.headlineLabel)
                    Spacer()
                    Button {
                        print("hi")
                    } label: {
                        Label("Edit", systemImage: "pencil")
                            .font(.theme.plainButton)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        withAnimation(.spring()) {
                            showAddSheet = true
                        }
                    } label: {
                        Label("Add", systemImage: "plus")
                            .font(.theme.plainButton)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            
            if vm.books.count == 0 {
                noResultView
            } else {
                booksView
            }
        }
        .padding(.top, 20)
        .bottomSheet(isPresented: $showAddSheet) {
            sheetContentView
        }
    }
    
    private var sheetContentView: some View {
        VStack(spacing: 30) {
            HStack {
                Text("Add")
                    .font(.theme.sheetTitle)
                Spacer()
                
                Button {
                    withAnimation(.spring()) {
                        showAddSheet = false
                    }
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(SheetDismissButtonStyle())
            }
            
            VStack(spacing: 10) {
                GroupedSection(title: "Camera", systemName: "camera.fill", text: "Through the camera, the name of the book is recognized as machine learning and the information is imported.") { }
                
                HStack(spacing: 8) {
                    GroupedSection(title: "Search", systemName: "magnifyingglass") {
                        showAddSearchView = true
                    }
                    GroupedSection(title: "Barcode", systemName: "barcode") { }
                }
            }
        }
        .fullScreenCover(isPresented: $showAddSearchView, onDismiss: {
            withAnimation(.spring()) {
                showAddSheet = false
            }
        }) {
            AddBookView(addCase: .search)
        }
    }
    
    private var booksView: some View {
        ScrollView {
            Spacer()
                .frame(height: 10)
            LazyVGrid(columns: columns, spacing: 30) {
                ForEach(vm.books) { book in
                    if let url = book.coverURL {
                        AsyncImage(url: url) { imagePhase in
                            imagePhase.image?
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(4)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .shadow(color: .theme.shadow.opacity(0.2), radius: 20, y: 20)
    }
    
    private var noResultView: some View {
        VStack(spacing: 30) {
            VStack(spacing: 16) {
                Image.seed
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
                
                Text("No results..")
                    .font(.theme.subHeadline)
            }
            .foregroundColor(.theme.tertiary)
            
            Button {
                withAnimation(.spring()) {
                    showAddSheet = true
                }
            } label: {
                Label("Add Book", systemImage: "plus")
            }
            .buttonStyle(FilledButtonStyle())

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension BookListView {
    
    private func getMovie() async -> [Item] {
        guard let url = URL(string: "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=ttberaser30311317001&Query=kakao&QueryType=Title&MaxResults=10&start=1&SearchTarget=Book&output=js&Cover=Big&Version=20131101") else {
            return []
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return []
            }

            let popularMovie = try JSONDecoder().decode(SearchResult.self, from: data)
            return popularMovie.item
        } catch {
            print(error)
            return []
        }
    }
}

struct GroupedSection: View {
    var title: String
    var systemName: String
    var text: String?
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                Label(title, systemImage: systemName)
                    .font(.theme.headline)
                if let text = text {
                    Text(text)
                        .font(.theme.footnote)
                }
            }
            .padding(20)
            .padding(.vertical, text == nil ? 10 : 0)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.theme.groupedBackground)
            )
        }
        .buttonStyle(.plain)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView()
            .preferredColorScheme(.light)
    }
}

