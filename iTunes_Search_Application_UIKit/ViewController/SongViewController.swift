//
//  SongViewController.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/3/15.
//

import UIKit
import SafariServices
import Kanna

class SongViewController: UIViewController {
    var song: Song
    
    var playingSong: Bool = false
    private var soundManager = SoundManager()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(song: Song) {
        self.song = song
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var songImageView: UIImageView = {
        let url = URL(string: song.collectionViewURL)!
        var image = UIImage(systemName: "music.mic.circle")
        let imageView = UIImageView(image: image)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 100
        PictureViewModel.getDataFromHTML(url: url, pictureHtmlIndex: 17) { data in
            image = UIImage(data: data)
            PictureViewModel.cropImage(uiImage: image!, magnification: 1.5) { newImage in
                DispatchQueue.main.async {
                    imageView.image = newImage
                }
            }
        }
        return imageView
    }()
    
    lazy var songNameTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PingFang SC", size: 28)
        label.textAlignment = .center
        return label
    }()
    
    lazy var artistNameTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PingFang SC", size: 28)
        label.textAlignment = .center
        return label
    }()
    
    lazy var albumNameTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PingFang SC", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    lazy var releaseDateTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PingFang SC", size: 28)
        label.textAlignment = .center
        return label
    }()
    
    lazy var albumIconTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PingFang SC", size: 18)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    lazy var artistIconTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "PingFang SC", size: 18)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    lazy var artistButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "person.fill"), for: .normal)
        button.setTitle("歌手", for: .normal)
        button.alignTextBelow()
        button.addTarget(self, action: #selector(artistButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var albumButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        button.setTitle("專輯", for: .normal)
        button.alignTextBelow()
        button.addTarget(self, action: #selector(albumButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var playButtonBackGround: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 36
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        var image = UIImage(systemName: "play.circle.fill")?
            .resized(toWidth: 72, isOpaque: false)?
            .withTintColor(UIColor.systemGreen)
        image?.withTintColor(UIColor.green)
        button.setImage(image, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 36
        button.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        title = song.trackName
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonAction))
        let safariButton = UIBarButtonItem(image: UIImage(systemName: "music.note.tv"), style: .plain, target: self, action: #selector(webPageButtonAction))
        navigationItem.rightBarButtonItems = [shareButton, safariButton]
        
        view.addSubview(songImageView)
        songImageView.translatesAutoresizingMaskIntoConstraints = false
        songImageView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -220).isActive = true
        songImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        songImageView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -100).isActive = true
        songImageView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 100).isActive = true
        
        songNameTitle.text = song.trackName
        view.addSubview(songNameTitle)
        songNameTitle.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 30).isActive = true
        songNameTitle.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        songNameTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        artistNameTitle.text = song.artistName
        view.addSubview(artistNameTitle)
        artistNameTitle.topAnchor.constraint(equalTo: songNameTitle.centerYAnchor, constant: 24).isActive = true
        artistNameTitle.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        artistNameTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        albumNameTitle.text = "專輯: " + song.collectionName
        view.addSubview(albumNameTitle)
        albumNameTitle.topAnchor.constraint(equalTo: artistNameTitle.centerYAnchor, constant: 24).isActive = true
        albumNameTitle.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        albumNameTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        releaseDateTitle.text = String(song.releaseDate.prefix(10))
        view.addSubview(releaseDateTitle)
        releaseDateTitle.topAnchor.constraint(equalTo: albumNameTitle.centerYAnchor, constant: 14).isActive = true
        releaseDateTitle.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        releaseDateTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let xUnit = view.frame.width / 3
        
        view.addSubview(albumButton)
        albumButton.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: xUnit).isActive = true
        albumButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        
        view.addSubview(artistButton)
        artistButton.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: xUnit*2).isActive = true
        artistButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        view.addSubview(playButtonBackGround)
        playButtonBackGround.translatesAutoresizingMaskIntoConstraints = false
        playButtonBackGround.widthAnchor.constraint(equalToConstant: 72).isActive = true
        playButtonBackGround.heightAnchor.constraint(equalToConstant: 72).isActive = true
        playButtonBackGround.trailingAnchor.constraint(equalTo: songImageView.trailingAnchor).isActive = true
        playButtonBackGround.bottomAnchor.constraint(equalTo: songImageView.bottomAnchor).isActive = true
        
        view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 72).isActive = true
        playButton.trailingAnchor.constraint(equalTo: songImageView.trailingAnchor).isActive = true
        playButton.bottomAnchor.constraint(equalTo: songImageView.bottomAnchor).isActive = true
        
        let urlString = song.previewURL
        soundManager.playSound(sound: urlString)
        
    }
    
    @objc func albumButtonAction() {
        print("TapAlbum")
        let navigationController = navigationController
        let newViewController = AlbumViewController(albumId: song.collectionId)
        navigationController!.pushViewController(newViewController, animated: true)
    }
    
    @objc func artistButtonAction() {
        print("TapArtist")
    }
    
    @objc func webPageButtonAction() {
        let url = URL(string: self.song.collectionViewURL)
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
            
        // text to share
        let text = self.song.collectionViewURL
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func playTapped() {
        print("PlaySound")
        DispatchQueue.main.async {
            let iconName = self.playingSong ? "pause.circle.fill": "play.circle.fill"
            let newImage = UIImage(systemName: iconName)?
                .resized(toWidth: 72, isOpaque: false)?
                .withTintColor(UIColor.systemGreen)
            self.playButton.setImage(newImage, for: .normal)
        }
        if (playingSong) {
            soundManager.queuePlayer?.pause()
        } else {
            soundManager.queuePlayer?.play()
        }
        playingSong.toggle()
    }
}

public extension UIButton {
  func alignTextBelow(spacing: CGFloat = 6.0)
  {
      if let image = self.imageView?.image
      {
          let imageSize: CGSize = image.size
          self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
          let labelString = NSString(string: self.titleLabel!.text!)
          let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font!])
          self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
      }
  }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

extension UIImage {

    convenience init?(imageName: String) {
        self.init(named: imageName)
        accessibilityIdentifier = imageName
    }

    // https://stackoverflow.com/a/40177870/4488252
    func imageWithColor (newColor: UIColor?) -> UIImage? {

        if let newColor = newColor {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)

            let context = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(.normal)

            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            context.clip(to: rect, mask: cgImage!)

            newColor.setFill()
            context.fill(rect)

            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            newImage.accessibilityIdentifier = accessibilityIdentifier
            return newImage
        }

        if let accessibilityIdentifier = accessibilityIdentifier {
            return UIImage(imageName: accessibilityIdentifier)
        }

        return self
    }
}
