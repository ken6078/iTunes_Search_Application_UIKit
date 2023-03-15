//
//  ArtistListViewModel.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/2/13.
//

import Foundation
import Combine

class ArtistListViewModel: ObservableObject{
    
    enum State: Comparable {
        case empty
        case good
        case isLoading
        case loadedAll
        case error(String)
    }
    
    @Published var searchText: String = ""
    @Published var artists: [Artist] = [Artist]()
    @Published var state: State = .empty{
        didSet{
            print("state chenged to: \(state)")
        }
    }
    
    let limit: Int = 20
    var page: Int = 0
    
    var subscriptions = Set<AnyCancellable>()
    
    func getArtistList(for searchText: String, completion: @escaping () -> Void) {
        
        guard !searchText.isEmpty else {
            self.state = .empty
            return
        }
        guard self.state == State.good else {return}
        
        let offset = limit * page
        let urlText = String(format: "https://itunes.apple.com/search?country=tw&media=music&term=\(searchText)&explicit=Yes&limit=\(self.limit)&offset=\(offset)&entity=allArtist")
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
                    let result = try JSONDecoder().decode(ArtistResult.self, from: data)
                    for artist in result.results {
                        self?.artists.append(artist)
                    }
                    self?.page += 1
                    self?.state = (result.results.count == self?.limit) ? .good : .loadedAll
                    print("fetched \(result.resultCount)")
                } catch {
                    print("ArtistResult Json Decode error: \(error)")
                    self?.state = .error("Json Decode error: \(error.localizedDescription)")
                }
            }
            completion()
        }.resume()
    }
    
    static func example() -> ArtistListViewModel {
        let vm = ArtistListViewModel()
        vm.searchText = "Mayday"
        return vm
    }
}
