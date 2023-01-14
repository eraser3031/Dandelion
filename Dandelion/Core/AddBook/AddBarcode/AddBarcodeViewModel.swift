//
//  AddBarcodeViewModel.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/17.
//

import Foundation

@MainActor
final class AddBarcodeViewModel: ObservableObject {
    
    let manager = CoreDataManager.shared
    let bookSearchService = BookSearchService()
    
    func search(isbn: String) async -> Item? {
        let item = await bookSearchService.lookup(isbn: isbn)
        guard let item else { return nil }
        return item
    }
    
    func addBooks(items: [Item]) {
        for item in items {
            let newBook = Book(context: manager.context)
            newBook.id = UUID()
            newBook.title = item.title
            newBook.author = item.author
            newBook.coverURL = URL(string: item.cover)
            
            let categorys = item.categoryName?.split(separator: ">")
            if let category = categorys?.last {
                newBook.genre = String(category)
            }
            
            newBook.isbn = item.isbn13
            let convertDate = DateFormatter.shared.date(from: item.pubDate)
            newBook.publishedDate = convertDate
            newBook.publisher = item.publisher
            
            let newShape = BookShape(context: manager.context)
            newShape.id = UUID()
            newShape.book = newBook
            newShape.pages = Int32(item.subInfo?.itemPage ?? 0)
            newShape.width = Int16(item.subInfo?.packing?.sizeWidth ?? 0)
            newShape.height = Int16(item.subInfo?.packing?.sizeHeight ?? 0)
            newShape.depth = Int16(item.subInfo?.packing?.sizeDepth ?? 0)
            
            newBook.price = Int32(item.priceStandard)
            manager.save()
        }
    }
}
