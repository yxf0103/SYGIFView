//
//  SYGIFModel.swift
//  SYGIFView
//
//  Created by yxf on 2022/1/15.
//

import UIKit

open class SYGifIndexItem {
    var index = 0
    var minDuration : TimeInterval = 0
    var maxDuration : TimeInterval = 0
    var indexImg : UIImage?
}

open class SYGIFSourceModel: NSObject {
    private var imgLocalpath : String?
    private var imgData : Data?
    
    private(set) var totalTime: TimeInterval = 0
    private var gifTimeIndexs = [SYGifIndexItem]()
    
    private var currentIndex: SYGifIndexItem?
    
    private lazy var imgSource: CGImageSource? = {
        guard let imgData = gifImageData() else{
            return nil
        }
        imgSource = CGImageSourceCreateWithData(imgData, nil)
        guard let imgSource = imgSource else{
            return nil
        }
        let imgCount = CGImageSourceGetCount(imgSource)
        gifTimeIndexs.removeAll()
        totalTime = 0
        for index in 0..<imgCount{
            guard let propertyDic = CGImageSourceCopyPropertiesAtIndex(imgSource, index, nil) else{
                continue
            }
            guard let gifDict = (propertyDic as NSDictionary)[kCGImagePropertyGIFDictionary] as? NSDictionary else{
                continue
            }
            guard let gifTime = (gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber)?.doubleValue else{
                continue
            }
            if gifTime > 0 {
                let indexTime = SYGifIndexItem.init()
                indexTime.index = index
                indexTime.minDuration = totalTime
                totalTime += gifTime
                indexTime.maxDuration = totalTime
                gifTimeIndexs.append(indexTime)
            }
        }
        return imgSource
    }()
    
    lazy var isGIF: Bool = {
        return gifTimeIndexs.count > 0
    }()
        
    private lazy var defaultImg: UIImage? = {
        guard let gifData = gifImageData() else { return nil }
        return UIImage.init(data: gifData as Data)
    }()
    
    convenience init(localpath:String?) {
        self.init()
        self.imgLocalpath = localpath
    }
    
    convenience init(imgData:Data?) {
        self.init()
        self.imgData = imgData
    }
}

public extension SYGIFSourceModel{
    
    func gifImageData() -> NSData?{
        if imgData != nil {
            return imgData as NSData?
        }
        guard let imgLocalpath = imgLocalpath else {
            return nil
        }
        return NSData.init(contentsOfFile: imgLocalpath)
    }
    
    
    func imgAtTime(time:TimeInterval) -> UIImage?{
        guard let imgSource = self.imgSource else {
            return self.defaultImg
        }
        
        if isGIF == false{
            return self.defaultImg
        }
        
        if time > totalTime{
            return currentIndex?.indexImg
        }

        if currentIndex != nil,
           currentIndex!.indexImg != nil,
           time >= currentIndex!.minDuration,
           time < currentIndex!.maxDuration{
            return currentIndex?.indexImg
        }
        currentIndex?.indexImg = nil
        for indexTime in gifTimeIndexs {
            if time >= indexTime.minDuration && time < indexTime.maxDuration {
                guard let subImgRef = CGImageSourceCreateImageAtIndex(imgSource, indexTime.index, nil) else{
                    continue
                }
                currentIndex = indexTime
                currentIndex?.indexImg = UIImage.init(cgImage: subImgRef)
                return currentIndex?.indexImg
            }
        }
        return self.defaultImg
    }
}
