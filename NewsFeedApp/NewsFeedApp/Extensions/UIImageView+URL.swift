//
//  UIImage+URL.swift
//  NewsFeedApp
//
//  Created by Эльдар Адельшин on 28.06.2021.
//

import UIKit

extension UIImageView {

   static let imageCache = NSCache<NSString, UIImage>()
    
        func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {

        self.image = nil
        let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if let cachedImage = UIImageView.imageCache.object(forKey: NSString(string: imageServerUrl)) {
            self.image = cachedImage
            return
        }

        if let url = URL(string: imageServerUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

                if error != nil {
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            UIImageView.imageCache.setObject(downloadedImage, forKey: NSString(string: imageServerUrl))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
