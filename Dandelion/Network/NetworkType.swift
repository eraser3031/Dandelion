// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct SearchResult: Codable {
    let version: String
    let logo: String?
    let title: String
    let link: String
    let pubDate: String
    let totalResults, startIndex, itemsPerPage: Int
    let query: String
    let searchCategoryID: Int
    let searchCategoryName: String
    let item: [Item]

    enum CodingKeys: String, CodingKey {
        case version, logo, title, link, pubDate, totalResults, startIndex, itemsPerPage, query
        case searchCategoryID = "searchCategoryId"
        case searchCategoryName, item
    }
}

// MARK: - Item
struct Item: Codable, Identifiable {
    
    var id: String {
        return String(itemID)
    }
    
    let title: String
    let link: String
    let author, pubDate, itemDescription, isbn: String
    let isbn13: String
    let itemID, priceSales, priceStandard: Int
    let mallType: String?
    let stockStatus: StockStatus
    let mileage: Int
    let cover: String
    let categoryID: Int?
    let categoryName: String?
    let publisher: String
    let salesPoint: Int?
    let adult: Bool?
    let customerReviewRank: Int
    let fixedPrice: Bool?
    let subInfo: SubInfo?
    let seriesInfo: SeriesInfo?

    enum CodingKeys: String, CodingKey {
        case title, link, author, pubDate
        case itemDescription = "description"
        case isbn, isbn13
        case itemID = "itemId"
        case priceSales, priceStandard, mallType, stockStatus, mileage, cover
        case categoryID = "categoryId"
        case categoryName, publisher, salesPoint, adult, customerReviewRank, fixedPrice, subInfo, seriesInfo
    }
}

struct SubInfo: Codable {
}

struct SeriesInfo: Codable {
    let seriesID: Int
    let seriesLink: String
    let seriesName: String

    enum CodingKeys: String, CodingKey {
        case seriesID = "seriesId"
        case seriesLink, seriesName
    }
}

enum StockStatus: String, Codable {
    case empty = ""
    case outOfPrint = "절판"
    case soldOut = "품절"
    case preSale = "예약판매"
}
