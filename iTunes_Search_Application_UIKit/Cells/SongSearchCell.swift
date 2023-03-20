//
//  SongCell.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/3/15.
//

import UIKit

class SongSearchCell: UITableViewCell {
    
    lazy var trackNameTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var artistNameTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var rightArrowUIImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")!.imageWithColor(newColor: UIColor.systemGray4)
        let songImageView = UIImageView(image: image)
        songImageView.translatesAutoresizingMaskIntoConstraints = false
        return songImageView
    }()
    
    func configure (_ song: Song) {
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
        let url = URL(string: song.artworkUrl100)!
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
        
        trackNameTitle.text = song.trackName
        contentView.addSubview(trackNameTitle)
        trackNameTitle.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 10).isActive = true
        trackNameTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28).isActive = true
        trackNameTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -12).isActive = true
        
        artistNameTitle.text = song.artistName
        contentView.addSubview(artistNameTitle)
        artistNameTitle.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: 10).isActive = true
        artistNameTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28).isActive = true
        artistNameTitle.topAnchor.constraint(equalTo: trackNameTitle.bottomAnchor, constant: 2).isActive = true
        artistNameTitle.textColor = .gray
        
        contentView.addSubview(rightArrowUIImageView)
        rightArrowUIImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        rightArrowUIImageView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        rightArrowUIImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rightArrowUIImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
}
