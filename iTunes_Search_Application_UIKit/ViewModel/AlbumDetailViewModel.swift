//
//  AlbumDetailViewModel.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/2/21.
//

import Foundation

class AlbumDetailViewModel: ObservableObject {
    enum State: Comparable {
        case empty
        case ready
        case error(String)
    }
    @Published var albumId: Int
    @Published var album: Album?
    @Published var songList: [Song] = [Song]()
    @Published var state: State
    
    init (albumId: Int) {
        self.albumId = albumId
        self.state = .empty
//        self.loadData()
    }
    
    func loadData(completion: @escaping () -> ()) {
        let urlText = String(format: "https://itunes.apple.com/lookup?country=tw&entity=song&id=\(albumId)&limit=20")
        guard let url = URL(string: urlText) else {return}

        
        URLSession.shared.dataTask(with: url){[weak self] data, response, error in
            if let error = error {
                print("URLSession error: \(error)")
                self?.state = .error("Could not load: \(error.localizedDescription)")
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(AlbumSongLookupResult.self, from: data)
                    for node in result.results {
                        if (node.wrapperType == "collection") {
                            self?.album = Album(albumSongLookup: node)
                        } else {
                            self?.songList.append(Song(albumSongLookup: node))
                        }
                    }
                    self?.songList.sort { self?.sortedSolve(s1: $0, s2: $1) ?? false }
                    self?.state = .ready
                    print("fetched \(result.resultCount)")
                } catch {
                    print("AlbumSongLookupResult Json Decode error: \(error)")
                    self?.state = .error("Json Decode error: \(error.localizedDescription)")
                }
            }
            completion()
        }.resume()
    }
    
    func sortedSolve(s1: Song, s2: Song) -> Bool {
        return s1.discNumber! * s1.trackCount! + s1.trackNumber! < s2.discNumber! * s2.trackCount! + s2.trackNumber!
    }
}
