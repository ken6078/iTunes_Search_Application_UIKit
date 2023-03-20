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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        return label
    }()
    
    lazy var trackNameTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .lightGray
        return label
    }()
    
    lazy var rightArrowUIImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")!.imageWithColor(newColor: UIColor.systemGray4)
        let songImageView = UIImageView(image: image)
        songImageView.translatesAutoresizingMaskIntoConstraints = false
        return songImageView
    }()
    
    func configure (_ song: Song) {
//        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        indexLabel.text = "\(song.trackNumber! + (song.discNumber!-1)*song.trackCount!)"
        contentView.addSubview(indexLabel)
        indexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        indexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        trackNameTitle.text = song.trackName
        contentView.addSubview(trackNameTitle)
        trackNameTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        trackNameTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60).isActive = true
        trackNameTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        timeLabel.text = String(
            format: "%d:%02d",
            song.trackTimeMillis/60000, //分鐘
            song.trackTimeMillis%60000/1000 //秒
        )
        
        contentView.addSubview(timeLabel)
//        timeLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -75).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(rightArrowUIImageView)
        rightArrowUIImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        rightArrowUIImageView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        rightArrowUIImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rightArrowUIImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
    
    
}
