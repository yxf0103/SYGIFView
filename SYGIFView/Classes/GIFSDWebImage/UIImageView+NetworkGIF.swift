//
//  UIImageView+NetworkGIF.swift
//  SYGIFView
//
//  Created by yxf on 2022/1/19.
//

import Foundation
import SDWebImage

@objc public extension UIImageView{
    func sy_startGifAnimation(url:String?,autoRepeat:Bool=false,endShowFirstImage:Bool=false) {
        guard let url = url else {
            return
        }
        guard let imgUrl = URL.init(string: url) else { return }
        let imageLoader = SDWebImageDownloader.shared
        imageLoader.downloadImage(with: imgUrl) {[weak self] _, imgData, _, _ in
            guard let imgData = imgData else { return }
            DispatchQueue.main.async {
                let sourceModel = SYGIFSourceModel.init(imgData: imgData)
                let infoModel = SYGifInfoModel.init(autoRepeat: autoRepeat, endShowFirstImg: endShowFirstImage)
                self?.sy_startGifAnimation(sourceModel: sourceModel, infoModel: infoModel)
            }
        }
    }
}

