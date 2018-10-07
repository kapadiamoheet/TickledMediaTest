//
//  Helper.swift
//  TickledMediaTest
//
//  Created by Mohit Kapadia on 07/10/18.
//  Copyright © 2018 Mohit Kapadia. All rights reserved.
//

import UIKit

let cache = NSCache<NSString,UIImage>()
class FetchImage {
    init() {
    }
    
    func imageFromURL(urlString:String, indexPath: IndexPath? ,callBack:@escaping ((UIImage?,IndexPath?)->Void)) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let executeOnMain : (UIImage?)->Void = { (image) in
            DispatchQueue.main.async {
                callBack(image, indexPath)
            }
        }
        
        if let img = cache.object(forKey: urlString as NSString) {
            executeOnMain(img)
        } else {
            let _ = self.downloadData(url: url) { (data) in
                if let d = data, let img = UIImage(data: d) {
                    cache.setObject(img, forKey: url.absoluteString as NSString)
                    executeOnMain(img)
                } else {
                    executeOnMain(nil)
                }
            }
        }
    }
    
    func downloadData(url:URL,
                      callback:@escaping (Data?)->Void
        ) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            callback(data)
        })
        task.resume()
        return task
    }
}
