// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
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
struct Item: Codable {
    let title: String
    let link: String
    let author, pubDate, itemDescription, isbn: String
    let isbn13: String
    let itemID, priceSales, priceStandard: Int
    let mallType: MallType
    let stockStatus: String
    let mileage: Int
    let cover: String
    let categoryID: Int
    let categoryName, publisher: String
    let salesPoint: Int
    let adult: Bool
    let customerReviewRank: Int
    let subInfo: SubInfo

    enum CodingKeys: String, CodingKey {
        case title, link, author, pubDate
        case itemDescription = "description"
        case isbn, isbn13
        case itemID = "itemId"
        case priceSales, priceStandard, mallType, stockStatus, mileage, cover
        case categoryID = "categoryId"
        case categoryName, publisher, salesPoint, adult, customerReviewRank, subInfo
    }
}

// MARK: - SubInfo
struct SubInfo: Codable {
}


enum MallType: String, Codable {
    case foreign = "FOREIGN"
}//
//// MARK: - Item
//struct Item: Codable {
//    let title: String
//    let link: String
//    let author, pubDate, itemDescription, isbn: String
//    let isbn13: String
//    let itemID, priceSales, priceStandard: Int
//    let mallType: MallType?
//    let stockStatus: StockStatus
//    let mileage: Int
//    let cover: String
//    let publisher: String
//    let salesPoint: Int?
//    let fixedPrice: Bool?
//    let customerReviewRank: Int
//    let seriesInfo: SeriesInfo?
//    let subInfo: SubInfo?
//
//    enum CodingKeys: String, CodingKey {
//        case title, link, author, pubDate
//        case itemDescription = "description"
//        case isbn, isbn13
//        case itemID = "itemId"
//        case priceSales, priceStandard, mallType, stockStatus, mileage, cover, publisher, salesPoint, fixedPrice, customerReviewRank, seriesInfo, subInfo
//    }
//}
//
//enum MallType: String, Codable {
//    case book = "BOOK"
//}
//
//// MARK: - SeriesInfo
//struct SeriesInfo: Codable {
//    let seriesID: Int
//    let seriesLink: String
//    let seriesName: String
//
//    enum CodingKeys: String, CodingKey {
//        case seriesID = "seriesId"
//        case seriesLink, seriesName
//    }
//}
//
//enum StockStatus: String, Codable {
//    case empty = ""
//    case 절판 = "절판"
//    case 품절 = "품절"
//}
//
//// MARK: - SubInfo
//struct SubInfo: Codable {
//    let ebookList: [EbookList]?
//    let usedList: UsedList?
//}
//
//// MARK: - EbookList
//struct EbookList: Codable {
//    let itemID: Int
//    let isbn: String
//    let priceSales: Int
//    let link: String
//
//    enum CodingKeys: String, CodingKey {
//        case itemID = "itemId"
//        case isbn, priceSales, link
//    }
//}
//
//// MARK: - UsedList
//struct UsedList: Codable {
//    let aladinUsed, userUsed: Used
//}
//
//// MARK: - Used
//struct Used: Codable {
//    let itemCount, minPrice: Int
//    let link: String
//}
