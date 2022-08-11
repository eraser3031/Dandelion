//
//  BookSearchService.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/28.
//

import Foundation

enum Region: String {
    case korean
    case foreign
}

class BookSearchService {
    
    let manager = NetworkingManager.shared
    let aladinURL = URL(string: "")

    func search(_ region: Region, text: String) async -> [Item] {
        let queryItems = [
            URLQueryItem(name: "ttbkey", value: "ttberaser30311317001"),
            URLQueryItem(name: "Query", value: text),
            URLQueryItem(name: "QueryType", value: "Title"),
            URLQueryItem(name: "MaxResults", value: "20"),
            URLQueryItem(name: "start", value: "1"),
            URLQueryItem(name: "SearchTarget", value: "Book"),
            URLQueryItem(name: "output", value: "js"),
            URLQueryItem(name: "Cover", value: "Big"),
            URLQueryItem(name: "Version", value: "20131101"),
        ]
        var components = URLComponents(string: "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx?")
        components?.queryItems = queryItems
        guard let url = components?.url else { return [] }
        let result = await manager.request(url: url)
        
        guard let result = result else { return [] }
        do {
            let searchResult = try JSONDecoder().decode(SearchResult.self, from: result)
            return searchResult.item
        } catch {
            print(error)
        }
        return []
    }
}
