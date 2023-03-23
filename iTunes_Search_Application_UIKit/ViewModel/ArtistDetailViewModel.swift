//
//  ArtistDetailViewModel.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/2/21.
//

import Foundation

class ArtistDetailViewModel: ObservableObject {
    enum State: Comparable {
        case empty
        case ready
        case error(String)
    }
    @Published var artistId: Int
    @Published var artist: Artist?
    @Published var albumList: [Album] = [Album]()
    @Published var state: State
    @Published var errorMessage: String?
    
    init (artistId: Int) {
        self.artistId = artistId
        self.state = .empty
//        self.loadData()
    }
    
    func loadData(completion: @escaping () -> ()) {
        let urlText = String(format: "https://itunes.apple.com/lookup?country=tw&entity=album&id=\(artistId)&limit=20&sort=recent")
        guard let url = URL(string: urlText) else {return}

        
        URLSession.shared.dataTask(with: url){[weak self] data, response, error in
            if let error = error {
                print("URLSession error: \(error)")
                self?.state = .error("Could not load: \(error.localizedDescription)")
                self?.errorMessage = "Could not load: \(error.localizedDescription)"
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(ArtistAlbumLookupResult.self, from: data)
                    for node in result.results {
                        if (node.wrapperType == "artist") {
                            self?.artist = Artist(artistAlbumLookup: node)
                        } else {
                            self?.albumList.append(Album(artistAlbumLookUp: node))
                        }
                    }
                    self?.albumList.sort { $0.releaseDate > $1.releaseDate }
                    self?.state = .ready
                    print("fetched \(result.resultCount)")
                } catch {
                    print("ArtistAlbumLookupResult Json Decode error: \(error)")
                    self?.state = .error("Json Decode error: \(error.localizedDescription)")
                    self?.errorMessage = "Json Decode error: \(error.localizedDescription)"
                }
            }
            completion()
        }.resume()
    }
}
