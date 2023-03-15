//
//  AlbumListViewModel.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/2/12.
//

import Foundation
import Combine

class AlbumListViewModel: ObservableObject{
    
    enum State: Comparable {
        case empty
        case good
        case isLoading
        case loadedAll
        case error(String)
    }
    
    @Published var albums: [Album] = [Album]()
    @Published var state: State = .empty{
        didSet{
            print("state chenged to: \(state)")
        }
    }
    
    let limit: Int = 20
    var page: Int = 0
    
    var subscriptions = Set<AnyCancellable>()
    
    func getAlbumList(for searchText: String, completion: @escaping () -> Void) {
        
        guard !searchText.isEmpty else {
            self.state = .empty
            return
        }
        guard self.state == State.good else {return}
        
        let offset = limit * page
        let urlText = String(format: "https://itunes.apple.com/search?country=tw&media=music&term=\(searchText)&explicit=Yes&limit=\(self.limit)&offset=\(offset)&entity=album")
        guard let encondeUrlText = urlText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: encondeUrlText) else {return}
        
        print("Get Data for: \(searchText)")
        state = .isLoading
        
        URLSession.shared.dataTask(with: url){[weak self] data, response, error in
            if let error = error {
                print("URLSession error: \(error)")
                self?.state = .error("Could not load: \(error.localizedDescription)")
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(AlbumResult.self, from: data)
                    for album in result.results {
                        self?.albums.append(album)
                    }
                    self?.page += 1
                    self?.state = (result.results.count == self?.limit) ? .good : .loadedAll
                    print("fetched \(result.resultCount)")
                } catch {
                    print("AlbumResult Json Decode error: \(error)")
                    self?.state = .error("Json Decode error: \(error.localizedDescription)")
                }
            }
            completion()
        }.resume()
    }
}
