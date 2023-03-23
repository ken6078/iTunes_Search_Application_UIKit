//
//  AlbumViewController.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/3/17.
//

import UIKit
import SafariServices

class AlbumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var albumDetailViewModel: AlbumDetailViewModel
    
    var errorMessage: String
    
    let songListView = UITableView()
    
    init(albumId: Int) {
        self.albumDetailViewModel = AlbumDetailViewModel(albumId: albumId)
        self.errorMessage = "ABC123"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .red
        label.textAlignment = .center
        label.text = "錯誤！\n"
        label.numberOfLines = 5
        return label
    }()
    
    lazy var loadingView: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }()
    
    lazy var albumImageView: UIImageView = {
        let url = URL(string: (albumDetailViewModel.album?.collectionViewURL)!)!
        var image = UIImage(systemName: "music.mic.circle")
        let imageView = UIImageView(image: image)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        PictureViewModel.getDataFromHTML(url: url, pictureHtmlIndex: 17) { data in
            image = UIImage(data: data)
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
        return imageView
    }()
    
    lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.textColor =  .lightGray
        label.numberOfLines = 3
        return label
    }()
    
    lazy var songListLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.text = "歌曲列表"
        label.numberOfLines = 3
        return label
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(loadingView)
        
        self.albumDetailViewModel.loadData {
            DispatchQueue.main.async {
                self.loadingView.removeFromSuperview()
                if (self.albumDetailViewModel.album?.collectionName == nil) {
                    print("ERROR")
                    self.errorMessage = self.albumDetailViewModel.errorMessage!
                    self.errorMessageLabel.text = "錯誤！\n" + self.errorMessage
                    self.view.addSubview(self.errorMessageLabel)
                    self.errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
                    self.errorMessageLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
                    self.errorMessageLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
                    self.errorMessageLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
                    return
                }
                
                self.title = self.albumDetailViewModel.album?.collectionName
                
                let shareButton = UIBarButtonItem(
                    barButtonSystemItem: .action,
                    target: self,
                    action: #selector(self.shareButtonAction)
                )
                let safariButton = UIBarButtonItem(
                    image: UIImage(systemName: "music.note.tv"),
                    style: .plain, target: self,
                    action: #selector(self.webPageButtonAction)
                )
                self.navigationItem.rightBarButtonItems = [shareButton, safariButton]
                
                self.view.addSubview(self.albumImageView)
                self.albumImageView.translatesAutoresizingMaskIntoConstraints = false
                self.albumImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
                self.albumImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 120).isActive = true
                self.albumImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
                self.albumImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 120).isActive = true
                
                self.albumNameLabel.text = self.albumDetailViewModel.album?.collectionName
                self.view.addSubview(self.albumNameLabel)
                self.albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
                self.albumNameLabel.bottomAnchor.constraint(equalTo: self.albumImageView.centerYAnchor, constant: -1).isActive = true
                self.albumNameLabel.leadingAnchor.constraint(equalTo: self.albumImageView.trailingAnchor, constant: 10).isActive = true
                self.albumNameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
                
                self.artistNameLabel.text = self.albumDetailViewModel.album?.artistName
                self.view.addSubview(self.artistNameLabel)
                self.artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
                self.artistNameLabel.topAnchor.constraint(equalTo: self.albumImageView.centerYAnchor, constant: 1).isActive = true
                self.artistNameLabel.leadingAnchor.constraint(equalTo: self.albumImageView.trailingAnchor, constant: 10).isActive = true
                self.artistNameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
                
                self.view.addSubview(self.songListLabel)
                self.songListLabel.translatesAutoresizingMaskIntoConstraints = false
                self.songListLabel.topAnchor.constraint(equalTo: self.albumImageView.bottomAnchor, constant: 10).isActive = true
                self.songListLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
                
                self.songListView.register(SongListCell.self, forCellReuseIdentifier: "SongListCell")
                self.songListView.delegate = self
                self.songListView.dataSource = self
                self.view.addSubview(self.songListView)
                self.songListView.translatesAutoresizingMaskIntoConstraints = false
                self.songListView.topAnchor.constraint(equalTo: self.songListLabel.bottomAnchor, constant: 10).isActive = true
                self.songListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                self.songListView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
                self.songListView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumDetailViewModel.songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongListCell", for: indexPath) as? SongListCell else {
            fatalError("SongCell is not defined!")
        }
        let song = albumDetailViewModel.songList[indexPath.row]
        cell.configure(song)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        let navigationController = navigationController
        let newViewController = SongViewController(song: albumDetailViewModel.songList[indexPath.row])
        navigationController!.pushViewController(newViewController, animated: true)
    }
    
    @objc func webPageButtonAction() {
        let url = URL(string: self.albumDetailViewModel.album!.collectionViewURL!)
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    
    @objc func shareButtonAction(_ sender: UIButton) {
            
        // text to share
        let text = self.albumDetailViewModel.album!.collectionViewURL!
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

}
