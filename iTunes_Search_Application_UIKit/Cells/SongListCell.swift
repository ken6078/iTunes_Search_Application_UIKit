//
//  SongListCell.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/3/20.
//

import UIKit

class SongListCell: UITableViewCell {
    
    lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var rightArrowImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")!.imageWithColor(newColor: UIColor.systemGray4)
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    func configure (_ song: Song) {
        indexLabel.text = "\(song.trackNumber! + (song.discNumber!-1)*song.trackCount!)"
        contentView.addSubview(indexLabel)
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        indexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        trackNameLabel.text = song.trackName
        contentView.addSubview(trackNameLabel)
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        trackNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60).isActive = true
        trackNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        timeLabel.text = String(
            format: "%d:%02d",
            song.trackTimeMillis/60000, //分鐘
            song.trackTimeMillis%60000/1000 //秒
        )
        
        contentView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(rightArrowImageView)
        rightArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        rightArrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        rightArrowImageView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        rightArrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rightArrowImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
}
