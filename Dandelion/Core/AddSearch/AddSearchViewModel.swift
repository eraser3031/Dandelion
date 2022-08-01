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
    
    let bookSearchService = BookSearchService()
    
    func search() async {
        searchedItems = await bookSearchService.search(.korean, text: searchText)
    }
}
