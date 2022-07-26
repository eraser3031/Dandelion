//
//  ContentView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var searchText: String = ""
    @State private var books: [String] = [""]
    @State private var showAddSheet = false
    
    private var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100), spacing: 12, alignment: .bottom)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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
            
            if books.count == 0 {
                noResultView
            } else {
                booksView
            }
            
        }
        .padding([.top, .horizontal], 20)
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
                    print("hi")
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(SheetDismissButtonStyle())
            }
            
            VStack(spacing: 10) {
                GroupedSection(title: "Camera", systemName: "camera.fill", text: "Through the camera, the name of the book is recognized as machine learning and the information is imported.")
                
                HStack(spacing: 8) {
                    GroupedSection(title: "Search", systemName: "magnifyingglass")
                    GroupedSection(title: "Barcode", systemName: "barcode")
                }
            }
        }
    }
    
    private var booksView: some View {
        ScrollView {
            Spacer()
                .frame(height: 10)
            LazyVGrid(columns: columns, spacing: 30) {
                ForEach(1..<6) { i in
                    Image("Book\(i)")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(4)
                        .onTapGesture {
                        }
                }
            }
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
                print("hi")
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
    
    var body: some View {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}

