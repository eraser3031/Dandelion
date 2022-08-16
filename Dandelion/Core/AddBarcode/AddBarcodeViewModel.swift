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
}
