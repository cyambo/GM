//
//  Codables.swift
//  iTunes Search
//
//  Created by Cristiana Yambo on 3/19/21.
//

import Foundation

struct ItunesSearch: Codable {
    let resultCount: Int?
    let results: [ItunesResult]?
}

struct ItunesResult: Codable {
    let wrapperType: String?
    let kind: String?
    let artistID: Int?
    let collectionID: Int?
    let trackID: Int?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let collectionCensoredName: String?
    let trackCensoredName: String?
    let artistViewURL: URL?
    let collectionViewURL: String?
    let trackViewURL: URL?
    let previewURL: URL?
    let artworkUrl30: URL?
    let artworkUrl60: URL
    let artworkUrl100: URL
    let collectionPrice: Double?
    let trackPrice: Double?
    let releaseDate: Date
    let collectionExplicitness: String?
    let trackExplicitness: String?
    let discCount: Int?
    let discNumber: Int?
    let trackCount: Int?
    let trackNumber: Int?
    let trackTimeMillis: Int?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let isStreamable: Bool?
    let collectionArtistName: String?
    let contentAdvisoryRating: String?
    let collectionArtistID: Int?

    func getReleaseDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        return dateFormatter.string(from: releaseDate)
    }
    func getPrice() -> String {
        guard let price = trackPrice, price > 0 else {
            return "No Price"
        }
        return "$\(price)"
    }
}
