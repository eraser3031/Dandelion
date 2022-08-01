//
//  BookListViewModel.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/28.
//

import SwiftUI

final class BookListViewModel: ObservableObject {
    @Published var books: [Book] = []
    let manager = CoreDataManager.shared
    
    init() {
        self.fetchBookList()
    }
    
    func fetchBookList() {
        let request = Book.fetchRequest()
        do {
            books = try manager.context.fetch(request)
        } catch {
            print("\(error)")
        }
    }
    
    func delete(book: Book) {
        manager.context.delete(book)
        manager.save()
        fetchBookList()
    }
}
