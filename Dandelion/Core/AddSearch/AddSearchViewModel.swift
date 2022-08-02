//
//  AddSearchViewModel.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/28.
//

import Foundation

@MainActor
final class AddSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchedItems: [Item] = []
    
    let manager = CoreDataManager.shared
    let bookSearchService = BookSearchService()
    
    func search() async {
        searchedItems = await bookSearchService.search(.korean, text: searchText)
    }
    
    func addBooks(items: [Item]) {
        for item in items {
            let newBook = Book(context: manager.context)
            newBook.id = UUID()
            newBook.title = item.title
            newBook.author = item.author
            newBook.coverURL = URL(string: item.cover)
            newBook.genre = item.categoryName
            newBook.isbn = item.isbn13
            let convertDate = DateFormatter.shared.date(from: item.pubDate)
            newBook.publishedDate = convertDate
            newBook.publisher = item.publisher
            newBook.price = Int32(item.priceStandard)
            manager.save()
        }
    }
}
