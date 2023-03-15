//
//  ArtistAlbumLookup.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/2/21.
//

import Foundation
// MARK: - ArtistAlbumLookupResult
struct ArtistAlbumLookupResult: Codable {
    let resultCount: Int
    let results: [ArtistAlbumLookup]
}

// MARK: - ArtistAlbumLookup
struct ArtistAlbumLookup: Codable {
    let wrapperType: String?
    let artistType: String?
    let artistName: String?
    let artistLinkURL: String?
    let artistID: Int?
    let amgArtistID: Int?
    let primaryGenreName: String?
    let primaryGenreID: Int?
    let collectionType: String?
    let collectionID: Int?
    let collectionName, collectionCensoredName: String?
    let artistViewURL, collectionViewURL: String?
    let artworkUrl60, artworkUrl100: String?
    let collectionPrice: Double?
    let collectionExplicitness: String?
    let trackCount: Int?
    let copyright: String?
    let country: String?
    let currency: String?
    let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case wrapperType, artistType, artistName
        case artistLinkURL = "artistLinkUrl"
        case artistID = "artistId"
        case amgArtistID = "amgArtistId"
        case primaryGenreName
        case primaryGenreID = "primaryGenreId"
        case collectionType
        case collectionID = "collectionId"
        case collectionName, collectionCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case artworkUrl60, artworkUrl100, collectionPrice, collectionExplicitness, trackCount, copyright, country, currency, releaseDate
    }
}
