//
//  UIImageView+extension.swift
//  VKNewsViewer
//
//  Copyright © 2018 NIKO. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func imageWithURL(url: URL){
        image = nil
        URLSession.shared.dataTask(with: url) { (imageData, responce, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if let data = imageData {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
            }.resume()
        
    }
}
