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

open class SYGIFModel: NSObject {
    private var imgLocalpath : String?
    
    private var totalTime: TimeInterval = 0
    private var gifTimeIndexs = [SYGifIndexItem]()
    var autoRepeat = false
    
    private var currentIndex: SYGifIndexItem?
    
    private lazy var imgSource: CGImageSource? = {
        guard let imgLocalpath = imgLocalpath else {
            return nil
        }
        let imgData = NSData.init(contentsOfFile: imgLocalpath)
        guard let imgData = imgData else{
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
        guard let imgLocalpath = imgLocalpath else { return nil }
        return UIImage.init(contentsOfFile: imgLocalpath)
    }()
    
    convenience init(localpath:String?) {
        self.init()
        self.imgLocalpath = localpath
    }
     
    func imgAtTime(time:TimeInterval) -> UIImage?{
        guard let imgSource = self.imgSource else {
            return self.defaultImg
        }
        
        if isGIF == false{
            return self.defaultImg
        }
        
        if time > totalTime,autoRepeat == false {
            return currentIndex?.indexImg
        }
        
        //修正时间
        var alterTime = time
        while alterTime > totalTime {
            alterTime -= totalTime
        }

        if currentIndex != nil, currentIndex!.indexImg != nil,alterTime >= currentIndex!.minDuration, alterTime < currentIndex!.maxDuration{
            return currentIndex?.indexImg
        }
        currentIndex?.indexImg = nil
        for indexTime in gifTimeIndexs {
            if alterTime >= indexTime.minDuration && alterTime < indexTime.maxDuration {
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
