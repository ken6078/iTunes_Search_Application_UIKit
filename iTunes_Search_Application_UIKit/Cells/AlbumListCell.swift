//
//  AlbumListCell.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/3/20.
//

import UIKit

class AlbumListCell: UITableViewCell {
    
    lazy var albumNameTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    lazy var rightArrowUIImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")!.imageWithColor(newColor: UIColor.systemGray4)
        let songImageView = UIImageView(image: image)
        songImageView.translatesAutoresizingMaskIntoConstraints = false
        return songImageView
    }()
    
    func configure (_ album: Album) {
//        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
        let url = URL(string: album.artworkUrl100)!
        let image = UIImage(systemName: "music.mic.circle")
        let songImageView = UIImageView(image: image)
        songImageView.layer.masksToBounds = true
        songImageView.layer.cornerRadius = 10
        PictureViewModel.getData(from: url) { data, response, error in
            if let error = error {
                print("URLSession error: \(error)")
            } else {
                DispatchQueue.main.async {
                    songImageView.image = UIImage(data: data!)
                }
            }
        }
        contentView.addSubview(songImageView)
        songImageView.translatesAutoresizingMaskIntoConstraints = false
        songImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        songImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        songImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        songImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        albumNameTitle.text = album.collectionName
        contentView.addSubview(albumNameTitle)
        albumNameTitle.translatesAutoresizingMaskIntoConstraints = false
        albumNameTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true
        albumNameTitle.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 10).isActive = true
        albumNameTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        
        releaseDateLabel.text = String(album.releaseDate.prefix(10))
        contentView.addSubview(releaseDateLabel)
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.topAnchor.constraint(equalTo: albumNameTitle.bottomAnchor, constant: 2).isActive = true
        releaseDateLabel.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 10).isActive = true
        releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        
        contentView.addSubview(rightArrowUIImageView)
        rightArrowUIImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        rightArrowUIImageView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        rightArrowUIImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rightArrowUIImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
}
