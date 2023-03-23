//
//  SongCell.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/3/15.
//

import UIKit

class SongSearchCell: UITableViewCell {
    
    lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    lazy var rightArrowImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")!.imageWithColor(newColor: UIColor.systemGray4)
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    func configure (_ song: Song) {
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
        let url = URL(string: song.artworkUrl100)!
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
        
        trackNameLabel.text = song.trackName
        contentView.addSubview(trackNameLabel)
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 10).isActive = true
        trackNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28).isActive = true
        trackNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -12).isActive = true
        
        artistNameLabel.text = song.artistName
        contentView.addSubview(artistNameLabel)
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 10).isActive = true
        artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28).isActive = true
        artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 2).isActive = true
        
        contentView.addSubview(rightArrowImageView)
        rightArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        rightArrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        rightArrowImageView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        rightArrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rightArrowImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
}
