//
//  BookSearchService.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/28.ㄹ  ㅊ
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
            URLQueryItem(name: "MaxResults", value: "40"),
            URLQueryItem(name: "start", value: "1"),
            URLQueryItem(name: "SearchTarget", value: region == .korean ? "Book" : "Foreign"),
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
    
    func lookup(isbn: String) async -> Item? {
        let queryItems = [
            URLQueryItem(name: "ttbkey", value: "ttberaser30311317001"),
            URLQueryItem(name: "itemIdType", value: "ISBN13"),
            URLQueryItem(name: "ItemId", value: isbn),
            URLQueryItem(name: "output", value: "js"),
            URLQueryItem(name: "Version", value: "20131101"),
            URLQueryItem(name: "Cover", value: "Big"),
            URLQueryItem(name: "OptResult", value: "packing")
        ]
        var components = URLComponents(string: "http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?")
        components?.queryItems = queryItems
        guard let url = components?.url else { return nil }
        let result = await manager.request(url: url)
        
        guard let result = result else { return nil }
        do {
            let searchResult = try JSONDecoder().decode(SearchResult.self, from: result)
            return searchResult.item.first
        } catch {
            print(error)
        }
        
        return nil
    }
}
