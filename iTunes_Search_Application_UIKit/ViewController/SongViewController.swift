//
//  SongViewController.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/3/15.
//

import UIKit
import Kanna

class SongViewController: UIViewController {
    var song: Song
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(song: Song) {
        self.song = song
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        title = song.trackName
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let url = URL(string: song.collectionViewURL)!
        var image = UIImage(systemName: "music.mic.circle")
        var songImageView = UIImageView(image: image)
        songImageView.layer.masksToBounds = true
        songImageView.layer.cornerRadius = 100
        PictureViewModel.getDataFromHTML(url: url, pictureHtmlIndex: 17) { data in
            image = UIImage(data: data)
            PictureViewModel.cropImage(uiImage: image!, magnification: 1.5) { newImage in
                DispatchQueue.main.async {
                    songImageView.image = newImage
                }
            }
        }
        view.addSubview(songImageView)
        songImageView.translatesAutoresizingMaskIntoConstraints = false
        songImageView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -220).isActive = true
        songImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        songImageView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -100).isActive = true
        songImageView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 100).isActive = true
        
    }

}
