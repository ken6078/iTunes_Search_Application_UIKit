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
    
    @Published var searchText: String = ""
    @Published var songs: [Song] = [Song]()
    @Published var state: State = .good{
        didSet{
            print("state chenged to: \(state)")
        }
    }
    
    let limit: Int = 20
    var page: Int = 0
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        $searchText
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink{[weak self] text in
                self?.state = .good
                self?.songs = []
                self?.page = 0
                self?.getSongList(for: text)
            }.store(in: &subscriptions)
        
    }
    
    func loadMore(){
        print("Load More For: \(self.searchText) @ Page: \(self.page)")
        getSongList(for: searchText)
    }
    
    func getSongList(for searchText: String) {
        
        guard !searchText.isEmpty else {
            self.state = .empty
            return
        }
        guard self.state == State.good else {return}
        
        let offset = limit * page
        let urlText = String(format: "https://itunes.apple.com/search?country=tw&media=music&term=\(searchText)&explicit=Yes&limit=\(self.limit)&offset=\(offset)&entity=song")
        guard let encondeUrlText = urlText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: encondeUrlText) else {return}
        
        print("Get Data for: \(searchText)")
        state = .isLoading
        
        URLSession.shared.dataTask(with: url){[weak self] data, response, error in
            if let error = error {
                print("URLSession error: \(error)")
                DispatchQueue.main.async {
                    self?.state = .error("Could not load: \(error.localizedDescription)")
                }
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(SongResult.self, from: data)
                    DispatchQueue.main.async {
                        for song in result.results {
                            self?.songs.append(song)
                        }
                    }
                    self?.page += 1
                    DispatchQueue.main.async {
                        self?.state = (result.results.count == self?.limit) ? .good : .loadedAll
                    }
                    print("fetched \(result.resultCount)")
                } catch {
                    print("SongResult Json Decode error: \(error)")
                    let str = String(decoding: data, as: UTF8.self)
                    print(str)
                    print(encondeUrlText)
                    DispatchQueue.main.async {
                        self?.state = .error("Json Decode error: \(error.localizedDescription)")
                    }
                }
            }
        }.resume()
    }
    
    static func example() -> SongListViewModel {
        let vm = SongListViewModel()
        vm.searchText = "Mayday"
        return vm
    }
}
