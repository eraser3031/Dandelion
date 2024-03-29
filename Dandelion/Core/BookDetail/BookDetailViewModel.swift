//
//  BookDetailViewModel.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/02.
//

import Foundation

@MainActor
final class BookDetailViewModel: ObservableObject {
    
    var book: Book
    @Published var rating: Rating
    @Published var bookmarks: [Bookmark] = []
    
    let manager = CoreDataManager.shared
    let bookSearchService = BookSearchService()
    
    init(book: Book) {
        self.book = book
        if let rating = book.rating {
            print(rating.score)
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
    
    func fetchBookShape() async {
        let subInfo = await bookSearchService.lookup(isbn: book.isbn ?? "")?.subInfo
        let bookShape = BookShape(context: manager.context)
        bookShape.id = UUID()
        bookShape.book = book
        bookShape.pages = Int32(subInfo?.itemPage ?? 0)
        bookShape.width = Int16(subInfo?.packing?.sizeWidth ?? 0)
        bookShape.height = Int16(subInfo?.packing?.sizeHeight ?? 0)
        bookShape.depth = Int16(subInfo?.packing?.sizeDepth ?? 0)
        manager.save()
    }
    
    func updateRating(score: Int, review: String) {
        rating.score = Int16(score)
        rating.review = review
        manager.save()
    }
    
    func updateBookmark(_ bookmark: Bookmark, page: Int, note: String) {
        bookmark.page = Int32(page)
        bookmark.note = note
        manager.save()
        fetchBookmarks()
    }
    
    func addBookmark(page: Int, note: String) {
        let newBookmark = Bookmark(context: manager.context)
        newBookmark.id = UUID()
        newBookmark.note = note
        newBookmark.page = Int32(page)
        newBookmark.book = book
        manager.save()
        fetchBookmarks()
    }
    
    func fetchBookmarks() {
        let request = Book.fetchRequest()
        let filter = NSPredicate(format: "id = %@", book.id! as CVarArg)
        request.predicate = filter
        do {
            var books: [Book] = []
            books = try manager.context.fetch(request)
            let fetchedBookmarks = books.first?.bookmarks?.allObjects as? [Bookmark]
            if let fetchedBookmarks = fetchedBookmarks {
                bookmarks = fetchedBookmarks
            }
        } catch {
            print("\(error)")
        }
    }
    
    func removeBook() {
        manager.context.delete(book)
        manager.save()
    }
    
    func removeBookmark(_ bookmark: Bookmark) {
        manager.context.delete(bookmark)
        manager.save()
        fetchBookmarks()
    }
}
