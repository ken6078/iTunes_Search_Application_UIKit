//
//  AlbumCell.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/3/15.
//

import UIKit

class AlbumSearchCell: UITableViewCell {
    
    lazy var collectionNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var rightArrowImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")!.imageWithColor(newColor: UIColor.systemGray4)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func configure (_ album: Album) {
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
        let url = URL(string: album.artworkUrl100)!
        let image = UIImage(systemName: "music.mic.circle")
        let songImageView = UIImageView(image: image)
        songImageView.layer.masksToBounds = true
        songImageView.backgroundColor = .white
        PictureViewModel.getData(from: url) { data, response, error in
            if let error = error {
                print("URLSession error: \(error)")
            } else {
                DispatchQueue.main.async {
                    songImageView.image = UIImage(data: data!)
                    songImageView.layer.cornerRadius = 10
                }
            }
        }
        
        contentView.addSubview(songImageView)
        songImageView.translatesAutoresizingMaskIntoConstraints = false
        songImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        songImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        songImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        songImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        collectionNameLabel.text = album.collectionName
        contentView.addSubview(collectionNameLabel)
        collectionNameLabel.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 10).isActive = true
        collectionNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28).isActive = true
        collectionNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -12).isActive = true
        
        artistNameLabel.text = album.artistName
        contentView.addSubview(artistNameLabel)
        artistNameLabel.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 10).isActive = true
        artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28).isActive = true
        artistNameLabel.topAnchor.constraint(equalTo: collectionNameLabel.bottomAnchor, constant: 2).isActive = true
        artistNameLabel.textColor = .gray
        
        contentView.addSubview(rightArrowImageView)
        rightArrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        rightArrowImageView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        rightArrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rightArrowImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
}
