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
    
    let searchTableView = UITableView()
    
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
        return picker
    }()
    
    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .red
        label.textAlignment = .center
        label.text = "錯誤！\n"
        label.numberOfLines = 5
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "搜尋"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.searchTextField.clearButtonMode = .never
        navigationItem.hidesSearchBarWhenScrolling = false
        
        stylePicker.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        view.addSubview(stylePicker)
        stylePicker.translatesAutoresizingMaskIntoConstraints = false
        stylePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stylePicker.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 30).isActive = true
        stylePicker.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        stylePicker.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        searchTableView.register(SongSearchCell.self, forCellReuseIdentifier: "SongCell")
        searchTableView.register(AlbumSearchCell.self, forCellReuseIdentifier: "AlbumCell")
        searchTableView.register(ArtistSearchCell.self, forCellReuseIdentifier: "ArtistCell")
        searchTableView.delegate = self
        searchTableView.dataSource = self
        view.addSubview(searchTableView)
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.topAnchor.constraint(equalTo: stylePicker.bottomAnchor).isActive = true
        searchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        searchTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        searchTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? SongSearchCell else {
                fatalError("SongSearchCell is not defined!")
            }
            let song = songListViewModel.songs[indexPath.row]
            cell.configure(song)
            return cell
        case .album:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as? AlbumSearchCell else {
                fatalError("AlbumSearchCell is not defined!")
            }
            let album = albumListViewModel.albums[indexPath.row]
            cell.configure(album)
            return cell
        case .artist:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as? ArtistSearchCell else {
                fatalError("ArtistSearchCell is not defined!")
            }
            let artist = artistListViewModel.artists[indexPath.row]
            cell.configure(artist)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigationController = navigationController
        switch(style) {
        case .song:
            let newViewController = SongViewController(song: songListViewModel.songs[indexPath.row])
            navigationController!.pushViewController(newViewController, animated: true)
        case .album:
            let newViewController = AlbumViewController(albumId: albumListViewModel.albums[indexPath.row].id)
            navigationController!.pushViewController(newViewController, animated: true)
        case .artist:
            let newViewController = ArtistViewController(artistId: artistListViewModel.artists[indexPath.row].id)
            navigationController!.pushViewController(newViewController, animated: true)
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
        self.searchTableView.reloadData()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        selectedSegmentIndex = stylePicker.selectedSegmentIndex
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        songListViewModel.songs = []
        albumListViewModel.albums = []
        artistListViewModel.artists = []
        do {
            searchTableView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
        print("searchText: ",searchText)
        
        songListViewModel.state = .good
        songListViewModel.songs = []
        songListViewModel.page = 0
        songListViewModel.getSongList(for: searchText) {
            DispatchQueue.main.async { [weak self] in
                switch (self?.songListViewModel.state) {
                case .error(let message):
                    self?.errorMessageLabel.text = "錯誤！\n" + message
                    self?.view.addSubview(self!.errorMessageLabel)
                    self?.errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
                    self?.errorMessageLabel.centerYAnchor.constraint(equalTo: (self?.searchTableView.centerYAnchor)!).isActive = true
                    self?.errorMessageLabel.centerXAnchor.constraint(equalTo: (self?.searchTableView.centerXAnchor)!).isActive = true
                    self?.errorMessageLabel.widthAnchor.constraint(equalTo: (self?.searchTableView.widthAnchor)!).isActive = true
                default:
                    self?.errorMessageLabel.removeFromSuperview()
                }
                self?.searchTableView.reloadData()
            }
        }
        
        albumListViewModel.state = .good
        albumListViewModel.albums = []
        albumListViewModel.page = 0
        albumListViewModel.getAlbumList(for: searchText) { [weak self] in
            DispatchQueue.main.async {
                switch (self?.albumListViewModel.state) {
                case .error(let message):
                    self?.errorMessageLabel.text = "錯誤！\n" + message
                    self?.view.addSubview(self!.errorMessageLabel)
                    self?.errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
                    self?.errorMessageLabel.centerYAnchor.constraint(equalTo: (self?.searchTableView.centerYAnchor)!).isActive = true
                    self?.errorMessageLabel.centerXAnchor.constraint(equalTo: (self?.searchTableView.centerXAnchor)!).isActive = true
                    self?.errorMessageLabel.widthAnchor.constraint(equalTo: (self?.searchTableView.widthAnchor)!).isActive = true
                default:
                    self?.errorMessageLabel.removeFromSuperview()
                }
                self?.searchTableView.reloadData()
            }
        }
        
        artistListViewModel.state = .good
        artistListViewModel.artists = []
        artistListViewModel.page = 0
        artistListViewModel.getArtistList(for: searchText) { [weak self] in
            DispatchQueue.main.async { [weak self] in
                switch (self?.artistListViewModel.state) {
                case .error(let message):
                    self?.errorMessageLabel.text = "錯誤！\n" + message
                    self?.view.addSubview(self!.errorMessageLabel)
                    self?.errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
                    self?.errorMessageLabel.centerYAnchor.constraint(equalTo: (self?.searchTableView.centerYAnchor)!).isActive = true
                    self?.errorMessageLabel.centerXAnchor.constraint(equalTo: (self?.searchTableView.centerXAnchor)!).isActive = true
                    self?.errorMessageLabel.widthAnchor.constraint(equalTo: (self?.searchTableView.widthAnchor)!).isActive = true
                default:
                    self?.errorMessageLabel.removeFromSuperview()
                }

                self?.searchTableView.reloadData()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > searchTableView.contentSize.height - 100 - scrollView.frame.height {
            switch (style) {
            case .song:
                guard songListViewModel.state == .good else {return}
                print("Load More For: \(searchText) @ Page: \(songListViewModel.page)")
                searchTableView.tableFooterView = createSpinenerFooter()
                songListViewModel.getSongList(for: searchText) { [weak self] in
                    DispatchQueue.main.async {
                        self?.searchTableView.tableFooterView = nil
                        self?.searchTableView.reloadData()
                    }
                }
            case .album:
                guard albumListViewModel.state == .good else {return}
                print("Load More For: \(searchText) @ Page: \(albumListViewModel.page)")
                searchTableView.tableFooterView = createSpinenerFooter()
                albumListViewModel.getAlbumList(for: searchText) { [weak self] in
                    DispatchQueue.main.async {
                        self?.searchTableView.tableFooterView = nil
                        self?.searchTableView.reloadData()
                    }
                }
            case .artist:
                guard artistListViewModel.state == .good else {return}
                print("Load More For: \(searchText) @ Page: \(artistListViewModel.page)")
                searchTableView.tableFooterView = createSpinenerFooter()
                artistListViewModel.getArtistList(for: searchText) { [weak self] in
                    DispatchQueue.main.async {
                        self?.searchTableView.tableFooterView = nil
                        self?.searchTableView.reloadData()
                    }
                }
            }
        }
    }
}
