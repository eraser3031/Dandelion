//
//  BookDetailViewModel.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/02.
//

import Foundation

final class BookDetailViewModel: ObservableObject {
    
    var book: Book
    @Published var rating: Rating
    @Published var bookmarks: [Bookmark] = []
    
    let manager = CoreDataManager.shared
    
    init(book: Book) {
        self.book = book
        if let rating = book.rating {
            self._rating = Published(initialValue: rating)
        } else {
            let rating = Rating(context: manager.context)
            rating.id = UUID()
            rating.book = book
            manager.save()
            self._rating = Published(initialValue: rating)
        }
        let bookmarks = book.bookmarks?.allObjects as? [Bookmark]
        if let bookmarks = bookmarks {
            self._bookmarks = Published(initialValue: bookmarks)
        }
    }
}
