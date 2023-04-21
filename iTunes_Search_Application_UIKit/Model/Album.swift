//
//  Album.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/2/12.
//

import Foundation

// MARK: - AlbumResult
struct AlbumResult: Codable {
    let resultCount: Int
    let results: [Album]
}

// MARK: - Result
struct Album: Codable, Identifiable {
    let wrapperType: String
    let collectionType: String
    let id: Int
    let artistID: Int
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

    enum CodingKeys: String, CodingKey {
        case wrapperType, collectionType
        case artistID = "artistId"
        case id = "collectionId"
        case amgArtistID = "amgArtistId"
        case artistName, collectionName, collectionCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case artworkUrl60, artworkUrl100, collectionPrice, collectionExplicitness, trackCount, copyright, country, currency, releaseDate, primaryGenreName
    }
    
    init(artistAlbumLookUp: ArtistAlbumLookup) {
        self.wrapperType = artistAlbumLookUp.wrapperType!
        self.collectionType = artistAlbumLookUp.collectionType!
        self.id = artistAlbumLookUp.collectionID!
        self.artistID = artistAlbumLookUp.artistID!
        self.amgArtistID = artistAlbumLookUp.amgArtistID
        self.artistName = artistAlbumLookUp.artistName!
        self.collectionName = artistAlbumLookUp.collectionName!
        self.collectionCensoredName = artistAlbumLookUp.collectionCensoredName!
        self.artistViewURL = artistAlbumLookUp.artistViewURL
        self.collectionViewURL = artistAlbumLookUp.collectionViewURL!
        self.artworkUrl60 = artistAlbumLookUp.artworkUrl60!
        self.artworkUrl100 = artistAlbumLookUp.artworkUrl100!
        self.collectionPrice = artistAlbumLookUp.collectionPrice
        self.collectionExplicitness = artistAlbumLookUp.collectionExplicitness!
        self.trackCount = artistAlbumLookUp.trackCount!
        self.copyright = artistAlbumLookUp.copyright
        self.country = artistAlbumLookUp.country!
        self.currency = artistAlbumLookUp.currency!
        self.releaseDate = artistAlbumLookUp.releaseDate!
        self.primaryGenreName = artistAlbumLookUp.primaryGenreName!
    }
    
    init(albumSongLookup: AlbumSongLookup) {
        self.wrapperType = albumSongLookup.wrapperType
        self.collectionType = albumSongLookup.collectionType!
        self.id = albumSongLookup.collectionID
        self.artistID = albumSongLookup.artistID
        self.amgArtistID = albumSongLookup.amgArtistID
        self.artistName = albumSongLookup.artistName
        self.collectionName = albumSongLookup.collectionName
        self.collectionCensoredName = albumSongLookup.collectionCensoredName
        self.artistViewURL = albumSongLookup.artistViewURL
        self.collectionViewURL = albumSongLookup.collectionViewURL
        self.artworkUrl60 = albumSongLookup.artworkUrl60
        self.artworkUrl100 = albumSongLookup.artworkUrl100
        self.collectionPrice = albumSongLookup.collectionPrice
        self.collectionExplicitness = albumSongLookup.collectionExplicitness
        self.trackCount = albumSongLookup.trackCount
        self.copyright = albumSongLookup.copyright
        self.country = albumSongLookup.country
        self.currency = albumSongLookup.currency
        self.releaseDate = albumSongLookup.releaseDate ?? "Don't know"
        self.primaryGenreName = albumSongLookup.primaryGenreName
    }
}
