//
//  ArtistCell.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/3/15.
//

import UIKit

class ArtistSearchCell: UITableViewCell {
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        return label
    }()
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    lazy var rightArrowImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")!.imageWithColor(newColor: UIColor.systemGray4)
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    func configure (_ artist: Artist) {
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
        let url = URL(string: artist.artistLinkURL)!
        var image = UIImage(systemName: "music.mic.circle")
        image = image!.resized(toWidth: 60.0, isOpaque: false)
        
        let artistImageView = UIImageView(image: image)
        artistImageView.backgroundColor = .white
        PictureViewModel.getDataFromHTML(url: url, pictureHtmlIndex: 16) { data in
            image = UIImage(data: data)
            PictureViewModel.cropImage(uiImage: image!, magnification: 2) { newImage in
                DispatchQueue.main.async {
                    artistImageView.image = newImage
                    artistImageView.layer.masksToBounds = true
                    artistImageView.layer.cornerRadius = 30
                }
            }
        }
        contentView.addSubview(artistImageView)
        artistImageView.translatesAutoresizingMaskIntoConstraints = false
        artistImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        artistImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        artistImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        artistImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        artistNameLabel.text = artist.artistName
        contentView.addSubview(artistNameLabel)
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.leadingAnchor.constraint(equalTo: artistImageView.trailingAnchor, constant: 10).isActive = true
        artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28).isActive = true
        artistNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(rightArrowImageView)
        rightArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        rightArrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        rightArrowImageView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        rightArrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rightArrowImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }

}
