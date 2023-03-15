//
//  AlbumSongLookup.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/2/21.
//

import Foundation

// MARK: - AlbumSongLookupResult
struct AlbumSongLookupResult: Codable {
    let resultCount: Int
    let results: [AlbumSongLookup]
}

// MARK: - Result
struct AlbumSongLookup: Codable {
    let wrapperType: String
    let collectionType: String?
    let artistID, collectionID: Int
    let amgArtistID: Int?
    let artistName: String
    let collectionName, collectionCensoredName: String
    let artistViewURL: String?
    let collectionViewURL: String?
    let artworkUrl60, artworkUrl100: String
    let collectionPrice: Double?
    let collectionExplicitness: String
    let trackCount: Int
    let copyright: String?
    let country: String
    let currency: String
    let releaseDate: String
    let primaryGenreName: String
    let kind: String?
    let trackID: Int?
    let trackName, trackCensoredName: String?
    let trackViewURL: String?
    let previewURL: String?
    let artworkUrl30: String?
    let trackPrice: Double?
    let trackExplicitness: String?
    let discCount, discNumber, trackNumber, trackTimeMillis: Int?
    let isStreamable: Bool?

    enum CodingKeys: String, CodingKey {
        case wrapperType, collectionType
        case artistID = "artistId"
        case collectionID = "collectionId"
        case amgArtistID = "amgArtistId"
        case artistName, collectionName, collectionCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case artworkUrl60, artworkUrl100, collectionPrice, collectionExplicitness, trackCount, copyright, country, currency, releaseDate, primaryGenreName, kind
        case trackID = "trackId"
        case trackName, trackCensoredName
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, trackPrice, trackExplicitness, discCount, discNumber, trackNumber, trackTimeMillis, isStreamable
    }
}
