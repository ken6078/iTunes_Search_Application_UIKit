//
//  SearchViewController.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/3/14.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UIScrollViewDelegate{
    
    let songListViewModel = SongListViewModel()
    let albumListViewModel = AlbumListViewModel()
    let artistListViewModel = ArtistListViewModel()
    
    let stylePicker = SearchViewController.segmentedControl
    var selectedSegmentIndex = 0
    
    let searchView = UITableView()
    
    var searchText: String = ""
    
    enum Style: Comparable {
        case song
        case album
        case artist
    }
    var style: Style = .song
    
    private let searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.placeholder = "輸入你想搜尋的項目"
        return controller
    }()
    
    private static var segmentedControl: UISegmentedControl = {
        let styleList = ["歌曲","專輯","歌手"]
        var picker = UISegmentedControl(items: styleList)
        picker.selectedSegmentIndex = 0
        picker.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "搜尋"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(stylePicker)
        stylePicker.translatesAutoresizingMaskIntoConstraints = false
        stylePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stylePicker.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 30).isActive = true
        stylePicker.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        stylePicker.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        searchView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchCell")
        searchView.register(SongCell.self, forCellReuseIdentifier: "SongCell")
        searchView.register(AlbumCell.self, forCellReuseIdentifier: "AlbumCell")
        searchView.register(ArtistCell.self, forCellReuseIdentifier: "ArtistCell")
        searchView.delegate = self
        searchView.dataSource = self
        view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.topAnchor.constraint(equalTo: stylePicker.bottomAnchor).isActive = true
        searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (style) {
        case .song:
            return songListViewModel.songs.count
        case .album:
            return albumListViewModel.albums.count
        case .artist:
            return artistListViewModel.artists.count
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (style) {
        case .song:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? SongCell else {
                fatalError("SongCell is not defined!")
            }
            let song = songListViewModel.songs[indexPath.row]
            cell.configure(song)
            return cell
        case .album:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as? AlbumCell else {
                fatalError("AlbumCell is not defined!")
            }
            let album = albumListViewModel.albums[indexPath.row]
            cell.configure(album)
            return cell
        case .artist:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as? ArtistCell else {
                fatalError("ArtistCell is not defined!")
            }
            let artist = artistListViewModel.artists[indexPath.row]
            cell.configure(artist)
            return cell
        }
    }
    
    private func createSpinenerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 80))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    @objc func segmentSelected(sender: UISegmentedControl)
    {
        let index = sender.selectedSegmentIndex
        if index == 0 {
            style = .song
        } else if index == 1 {
            style = .album
        } else if index == 2 {
            style = .artist
        }
        print("searchView.reloadData()")
        self.searchView.reloadData()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        print("didPresentSearchController")
        selectedSegmentIndex = stylePicker.selectedSegmentIndex
        if (selectedSegmentIndex != 0) {
            self.stylePicker.setEnabled(false, forSegmentAt: 0)
        }
        if (selectedSegmentIndex != 1){
            self.stylePicker.setEnabled(false, forSegmentAt: 1)
        }
        if (selectedSegmentIndex != 2){
            self.stylePicker.setEnabled(false, forSegmentAt: 2)
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        print("willDismissSearchController")
        self.stylePicker.setEnabled(true, forSegmentAt: 0)
        self.stylePicker.setEnabled(true, forSegmentAt: 1)
        self.stylePicker.setEnabled(true, forSegmentAt: 2)
        songListViewModel.songs = []
        albumListViewModel.albums = []
        artistListViewModel.artists = []
        searchView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText: ",searchText)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
        
        switch (style) {
        case .song:
            songListViewModel.state = .good
            songListViewModel.songs = []
            songListViewModel.page = 0
            songListViewModel.getSongList(for: searchText) {
                DispatchQueue.main.async {
                    self.searchView.reloadData()
                }
            }
        case .album:
            albumListViewModel.state = .good
            albumListViewModel.albums = []
            albumListViewModel.page = 0
            albumListViewModel.getAlbumList(for: searchText) {
                DispatchQueue.main.async {
                    print("Reload")
                    self.searchView.reloadData()
                }
            }
        case .artist:
            artistListViewModel.state = .good
            artistListViewModel.artists = []
            artistListViewModel.page = 0
            artistListViewModel.getArtistList(for: searchText) {
                DispatchQueue.main.async {
                    self.searchView.reloadData()
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > searchView.contentSize.height - 100 - scrollView.frame.height {
            switch (style) {
            case .song:
                guard songListViewModel.state == .good else {return}
                print("Load More For: \(searchText) @ Page: \(songListViewModel.page)")
                searchView.tableFooterView = createSpinenerFooter()
                songListViewModel.getSongList(for: searchText){
                    DispatchQueue.main.async {
                        self.searchView.tableFooterView = nil
                        self.searchView.reloadData()
                    }
                }
            case .album:
                guard albumListViewModel.state == .good else {return}
                print("Load More For: \(searchText) @ Page: \(albumListViewModel.page)")
                searchView.tableFooterView = createSpinenerFooter()
                albumListViewModel.getAlbumList(for: searchText){
                    DispatchQueue.main.async {
                        self.searchView.tableFooterView = nil
                        self.searchView.reloadData()
                    }
                }
            case .artist:
                guard artistListViewModel.state == .good else {return}
                print("Load More For: \(searchText) @ Page: \(artistListViewModel.page)")
                searchView.tableFooterView = createSpinenerFooter()
                artistListViewModel.getArtistList(for: searchText){
                    DispatchQueue.main.async {
                        self.searchView.tableFooterView = nil
                        self.searchView.reloadData()
                    }
                }
                
            }
        }
    }
    
}
