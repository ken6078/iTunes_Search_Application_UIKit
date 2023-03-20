//
//  AlbumCell.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/3/15.
//

import UIKit

class AlbumSearchCell: UITableViewCell {
    
    lazy var collectionNameTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var artistNameTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure (_ album: Album) {
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
        
        collectionNameTitle.text = album.collectionName
        contentView.addSubview(collectionNameTitle)
        collectionNameTitle.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 10).isActive = true
        collectionNameTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
        collectionNameTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -12).isActive = true
        
        artistNameTitle.text = album.artistName
        contentView.addSubview(artistNameTitle)
        artistNameTitle.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 10).isActive = true
        artistNameTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28).isActive = true
        artistNameTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 12).isActive = true
        artistNameTitle.textColor = .gray
    }

}
