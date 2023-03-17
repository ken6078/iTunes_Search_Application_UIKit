//
//  PictureViewModel.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/3/16.
//

import UIKit
import Kanna

class PictureViewModel: ObservableObject {
    public static func cropImage(uiImage: UIImage, magnification: Double, completion: @escaping (UIImage) -> ()) {
        let sourceImage = uiImage

        // The shortest side
        let sideLength = min(
            sourceImage.size.width,
            sourceImage.size.height
        ) / magnification

        // Determines the x,y coordinate of a centered
        // sideLength by sideLength square
        let sourceSize = sourceImage.size
        let xOffset = (sourceSize.width - sideLength) / 2.0
        let yOffset = (sourceSize.height - sideLength) / 2.0

        // The cropRect is the rect of the image to keep,
        // in this case centered
        let cropRect = CGRect(
            x: xOffset,
            y: yOffset,
            width: sideLength,
            height: sideLength
        ).integral

        // Center crop the image
        let sourceCGImage = sourceImage.cgImage!
        let croppedCGImage = sourceCGImage.cropping(
            to: cropRect
        )!
        completion(UIImage(cgImage: croppedCGImage))
    }
    
    public static func getDataFromHTML(url: URL, pictureHtmlIndex: Int, completion: @escaping (Data) -> ()) {
        //從網頁中獲取歌手圖片位置
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data, let html = String(data: data, encoding: .utf8) {
                print("Get")
                if let doc = try? HTML(html: html, encoding: .utf8) {
                    print(doc.css("meta").count)
                    // 以css找特定item
                    if (doc.css("meta").count < pictureHtmlIndex) {
                        print("HTML parser error")
                        return
                    }
                    guard let imageURL = URL(string: String(doc.css("meta")[pictureHtmlIndex]["content"]!)) else {return}
                    URLSession.shared.dataTask(with: imageURL) {data, response, error in
                        if let error = error {
                            print("URLSession error: \(error)")
                        } else {
                            completion(data!)
                        }
                    }.resume()
                } else {
                    print("HTML parser error")
                }
            } else {
                print("Nodata")
            }
        }.resume()
    }
    
    public static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
