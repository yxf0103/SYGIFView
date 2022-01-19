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
    private var isGif: Bool = false
    private var gifTimeIndexs = [TimeInterval]()
    var autoRepeat = false
    
    private var currentIndex = -1
    private var currentImage: UIImage?
    
    private lazy var imgSource: CGImageSource? = {
        isGif = false
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
                gifTimeIndexs.append(0)
                continue
            }
            guard let gifDict = (propertyDic as NSDictionary)[kCGImagePropertyGIFDictionary] as? NSDictionary else{
                gifTimeIndexs.append(0)
                continue
            }
            guard let gifTime = (gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber)?.doubleValue else{
                gifTimeIndexs.append(0)
                continue
            }
            totalTime += gifTime
            gifTimeIndexs.append(gifTime)
        }
        isGif = totalTime > 0
        return imgSource
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
        
        if isGif == false{
            return self.defaultImg
        }
        
        if time > totalTime,autoRepeat == false {
            return currentImage
        }
        
        //修正时间
        var alterTime = time
        while alterTime > totalTime {
            alterTime -= totalTime
        }
        
        var tmpTime:TimeInterval = 0
        let count = gifTimeIndexs.count
        for index in 0..<count{
           let subTime = gifTimeIndexs[index]
            tmpTime += subTime
            if tmpTime >= alterTime{
                guard let subImgRef = CGImageSourceCreateImageAtIndex(imgSource, index, nil) else{
                    continue
                }
                if currentIndex != index {
                    currentIndex = index
                    currentImage = UIImage.init(cgImage: subImgRef)
                }
                return currentImage
            }
        }
        return self.defaultImg
    }
    
}
