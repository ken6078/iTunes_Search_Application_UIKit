//
//  ArtistViewController.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/3/20.
//

import UIKit
import SafariServices

class ArtistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var artistDetailViewModel: ArtistDetailViewModel
    
    var errorMessage: String
    
    let albumListView = UITableView()
    
    init(artistId: Int) {
        self.artistDetailViewModel = ArtistDetailViewModel(artistId: artistId)
        self.errorMessage = ""
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var loadingView: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }()
    
    lazy var albumImageView: UIImageView = {
        let url = URL(string: (artistDetailViewModel.artist?.artistLinkURL)!)!
        var image = UIImage(systemName: "music.mic.circle")
        let imageView = UIImageView(image: image)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 52.5
        PictureViewModel.getDataFromHTML(url: url, pictureHtmlIndex: 17) { data in
            image = UIImage(data: data)
            PictureViewModel.cropImage(uiImage: image!, magnification: 1.5) { newImage in
                DispatchQueue.main.async {
                    imageView.image = newImage
                }
            }
        }
        return imageView
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    
    lazy var albumListLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.text = "最新專輯"
        label.numberOfLines = 3
        return label
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(loadingView)
        
        self.artistDetailViewModel.loadData {
            DispatchQueue.main.async {
                self.loadingView.removeFromSuperview()

                if (self.artistDetailViewModel.artist?.artistName == nil) {
                    print("ERROR")
                    self.view.backgroundColor = .red
                    return
                }
                
                self.title = self.artistDetailViewModel.artist?.artistName
                
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
                
                self.artistNameLabel.text = self.artistDetailViewModel.artist?.artistName
                self.view.addSubview(self.artistNameLabel)
                self.artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
                self.artistNameLabel.centerYAnchor.constraint(equalTo: self.albumImageView.centerYAnchor).isActive = true
                self.artistNameLabel.leadingAnchor.constraint(equalTo: self.albumImageView.trailingAnchor, constant: 10).isActive = true
                self.artistNameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
                
                self.view.addSubview(self.albumListLabel)
                self.albumListLabel.translatesAutoresizingMaskIntoConstraints = false
                self.albumListLabel.topAnchor.constraint(equalTo: self.albumImageView.bottomAnchor, constant: 10).isActive = true
                self.albumListLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
                
                self.albumListView.register(AlbumListCell.self, forCellReuseIdentifier: "AlbumListCell")
                self.albumListView.delegate = self
                self.albumListView.dataSource = self
                self.view.addSubview(self.albumListView)
                self.albumListView.translatesAutoresizingMaskIntoConstraints = false
                self.albumListView.topAnchor.constraint(equalTo: self.albumListLabel.bottomAnchor, constant: 10).isActive = true
                self.albumListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                self.albumListView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
                self.albumListView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistDetailViewModel.albumList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumListCell", for: indexPath) as? AlbumListCell else {
            fatalError("AlbumListCell is not defined!")
        }
        let album = artistDetailViewModel.albumList[indexPath.row]
        cell.configure(album)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigationController = navigationController
        let newViewController = AlbumViewController(albumId: artistDetailViewModel.albumList[indexPath.row].id)
        navigationController!.pushViewController(newViewController, animated: true)
    }
    
    @objc func webPageButtonAction() {
        let url = URL(string: self.artistDetailViewModel.artist!.artistLinkURL)
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
            
        // text to share
        let text = self.artistDetailViewModel.artist!.artistLinkURL
        
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
