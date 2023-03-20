//
//  ArtistCell.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/3/15.
//

import UIKit

class ArtistSearchCell: UITableViewCell {
    lazy var artistNameTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    lazy var rightArrowUIImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")!.imageWithColor(newColor: UIColor.systemGray4)
        let songImageView = UIImageView(image: image)
        songImageView.translatesAutoresizingMaskIntoConstraints = false
        return songImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure (_ artist: Artist) {
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
        let url = URL(string: artist.artistLinkURL)!
        var image = UIImage(systemName: "music.mic.circle")
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
        
        artistNameTitle.text = artist.artistName
        contentView.addSubview(artistNameTitle)
        artistNameTitle.leadingAnchor.constraint(equalTo: artistImageView.trailingAnchor, constant: 10).isActive = true
        artistNameTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28).isActive = true
        artistNameTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(rightArrowUIImageView)
        rightArrowUIImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        rightArrowUIImageView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        rightArrowUIImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rightArrowUIImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }

}
