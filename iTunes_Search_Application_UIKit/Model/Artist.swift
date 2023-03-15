//
//  Artist.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/2/13.
//

import Foundation

// MARK: - ArtistResult
struct ArtistResult: Codable {
    let resultCount: Int
    let results: [Artist]
}

// MARK: - Artist
struct Artist: Codable, Identifiable {
    let id: Int
    let wrapperType: String
    let artistType: String
    var artistName: String
    let artistLinkURL: String

    enum CodingKeys: String, CodingKey {
        case wrapperType, artistType, artistName
        case artistLinkURL = "artistLinkUrl"
        case id = "artistId"
    }
    
    init (id: Int, wrapperType: String, artistType: String, artistName: String, artistLinkURL: String) {
        self.id = id
        self.wrapperType = wrapperType
        self.artistType = artistType
        self.artistName = artistName
        self.artistLinkURL = artistLinkURL
    }
    
    init (artistAlbumLookup: ArtistAlbumLookup) {
        self.id = artistAlbumLookup.artistID!
        self.wrapperType = artistAlbumLookup.wrapperType!
        self.artistType = artistAlbumLookup.artistType!
        self.artistName = artistAlbumLookup.artistName!
        self.artistLinkURL = artistAlbumLookup.artistLinkURL!
    }
    
    static func example() -> Artist {
        Artist(
            id: 300117743,
            wrapperType: "artist",
            artistType: "Artist",
            artistName: "周杰倫",
            artistLinkURL: "https://music.apple.com/tw/artist/%E5%91%A8%E6%9D%B0%E5%80%AB/300117743?uo=4")
    }
}
