//
//  SongListViewModel.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/2/3.
//

import Foundation
import Combine

class SongListViewModel: ObservableObject{
    
    enum State: Comparable {
        case empty
        case good
        case isLoading
        case loadedAll
        case error(String)
    }
    
    @Published var songs: [Song] = [Song]()
    @Published var state: State = .empty{
        didSet{
            print("state chenged to: \(state)")
        }
    }
    
    let limit: Int = 20
    var page: Int = 0
    
    var subscriptions = Set<AnyCancellable>()
    
    func getSongList(for searchText: String, completion: @escaping () -> Void) {
        
        guard !searchText.isEmpty else {
            self.state = .empty
            completion()
            return
        }
        guard self.state == State.good else {return}
        
        let offset = limit * page
        let urlText = String(format: "https://itunes.apple.com/search?country=tw&media=music&term=\(searchText)&explicit=Yes&limit=\(self.limit)&offset=\(offset)&entity=song")
        guard let encondeUrlText = urlText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: encondeUrlText) else {return}

        state = .isLoading
        
        URLSession.shared.dataTask(with: url){[weak self] data, response, error in
            if let error = error {
                print("URLSession error: \(error)")
                self?.state = .error("Could not load: \(error.localizedDescription)")
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(SongResult.self, from: data)
                    for song in result.results {
                        self?.songs.append(song)
                    }
                    self?.page += 1
                    self?.state = (result.results.count == self?.limit) ? .good : .loadedAll
                    print("fetched \(result.resultCount)")
                } catch {
                    print("SongResult Json Decode error: \(error)")
                    let str = String(decoding: data, as: UTF8.self)
                    print(str)
                    print(encondeUrlText)
                    self?.state = .error("Json Decode error: \(error.localizedDescription)")
                }
            }
            completion()
        }.resume()
    }
}
