//
//  ASImageManager.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 1/28/16.
//  Copyright © 2016 Build Apps. All rights reserved.
//

import AsyncDisplayKit
import AlamofireImage
import Foundation

class ASImageManger: NSObject, ASImageCacheProtocol, ASImageDownloaderProtocol {
    static let sharedInstance = ASImageManger()
    
    func fetchCachedImageWithURL(URL: NSURL?, callbackQueue: dispatch_queue_t?, completion: (CGImage?) -> Void) {
        if URL.isNil {
            completion(nil)
            return
        }
        
        let imageCache = UIImageView.af_sharedImageDownloader.imageCache
        let image = imageCache?.imageForRequest(NSURLRequest(URL: URL!), withAdditionalIdentifier: nil)
        dispatch_async(callbackQueue ?? dispatch_get_main_queue()) { () -> Void in
            completion(image?.CGImage)
        }
    }
    
    func downloadImageWithURL(URL: NSURL, callbackQueue: dispatch_queue_t?, downloadProgressBlock: ((CGFloat) -> Void)?, completion: ((CGImage?, NSError?) -> Void)?) -> AnyObject? {
        let imageDownloader = UIImageView.af_sharedImageDownloader
        
        return imageDownloader.downloadImage(URLRequest: NSURLRequest(URL: URL)) { response in
            guard let completion = completion else {
                return
            }
            
            dispatch_async(callbackQueue ?? dispatch_get_main_queue()) { () -> Void in
                completion(response.result.value?.CGImage, response.result.error)
            }
        }
    }
    
    func cancelImageDownloadForIdentifier(downloadIdentifier: AnyObject?) {
        guard let activeRequestReceipt = downloadIdentifier as? RequestReceipt else {
            return
        }
        
        let imageDownloader = UIImageView.af_sharedImageDownloader
        imageDownloader.cancelRequestForRequestReceipt(activeRequestReceipt)
    }
}