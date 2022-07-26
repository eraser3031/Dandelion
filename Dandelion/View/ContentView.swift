//
//  ContentView.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var searchText: String = ""
    @State private var books: [String] = []
    
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
                    print("hi")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}