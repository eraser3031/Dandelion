//
//  ContentView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/23.
//

import SwiftUI
import Kingfisher

struct BookListView: View {
    
    @StateObject private var vm = BookListViewModel()
    @State private var searchText: String = ""
    @State private var showAddSheet = false
    @State private var showAddBookCase: AddCase?
    @State private var showAddBarcodeView = false
    @State private var isEdit = false
    @State private var selectedBook: Book?
    @State private var showAR = false
    
    private var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100), spacing: 20, alignment: .bottom)
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    HStack {
                        Image.logo
                            .resizable()
                            .foregroundColor(.theme.dandelion)
                            .frame(width: 32, height: 32)
                        
                        Spacer()
                        
                        Button {
                            showAR = true
                        } label: {
                            Image(systemName: "arkit")
                                .font(.theme.title2)
                        }
                        .buttonStyle(.plain)
                        .fullScreenCover(isPresented: $showAR) {
                            ARBookView(books: vm.books)
                        }
                    }
                    
                    SearchBar(text: $searchText)
                    
                    HStack(alignment: .center, spacing: 16) {
                        Text("132")
                            .font(.theme.headlineLabel)
                        Spacer()
                        
                        Button {
                            withAnimation(.spring()) {
                                isEdit.toggle()
                            }
                        } label: {
                            Group {
                                if isEdit {
                                    Text("Done")
                                } else {
                                    Label("Edit", systemImage: "pencil")
                                }
                            }
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
            .toolbar(.hidden, for: .navigationBar)
            .padding(.top, 20)
            .bottomSheet(isPresented: $showAddSheet) {
                sheetContentView
            }
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
                        showAddBookCase = .search
                    }
                    GroupedSection(title: "Barcode", systemName: "barcode") {
                        showAddBookCase = .barcode
                    }
                }
            }
        }
        .fullScreenCover(item: $showAddBookCase, onDismiss: {
            withAnimation(.spring()) {
                showAddSheet = false
                vm.fetchBookList()
            }
        }) { item in
            AddBookView(addCase: item)
        }
    }
    
    private var booksView: some View {
        ScrollView {
            Spacer()
                .frame(height: 10)
            LazyVGrid(columns: columns, spacing: 40) {
                ForEach(vm.books) { book in
                    BookListCell(book: book, isEdit: isEdit) {
                        withAnimation(.spring()) {
                            vm.delete(book: book)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
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

struct BookListCell: View {
    
    var book: Book
    var isEdit: Bool
    let removeAction: () -> Void
    
    @State private var deleteBookDialog = false
    
    var body: some View {
        if let url = book.coverURL {
            ZStack(alignment: .bottomTrailing) {
                NavigationLink(destination: {
                    BookDetailView(book: book)
                        .toolbar(.hidden, for: .navigationBar)
                }, label: {
                    KFImage(url)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(4)
                        .overlay {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .stroke(Color.theme.labelBackground, lineWidth: 0.5)
                        }
                })
                .overlay(
                    Group {
                        if isEdit {
                            Color.theme.primary.opacity(0.2)
                        }
                    }
                )
                
                ZStack {
                    
                    if isEdit {
                        Button {
                            deleteBookDialog = true
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(SheetDismissButtonStyle())
                        .padding(8)
                    }
                }
            }
            .confirmationDialog("Are you sure?", isPresented: $deleteBookDialog, titleVisibility: .visible) {
                Button("Delete Book", role: .destructive) {
                    removeAction()
                }
                Button("Cancel", role: .cancel) {
                    deleteBookDialog = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView()
            .preferredColorScheme(.light)
    }
}

