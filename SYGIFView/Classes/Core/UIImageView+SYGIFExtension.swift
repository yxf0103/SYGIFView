//
//  UIImageView+SYGIFExtension.swift
//  SYGIFView
//
//  Created by yxf on 2022/1/15.
//

import Foundation

let sy_gif_source_key = "sy_gif_source_key"
let sy_gif_display_key = "sy_gif_display_key"
let sy_gif_info_key = "sy_gif_info_key"

@objc public extension UIImageView{
    
    func sy_gifSourceModel() -> SYGIFSourceModel? {
        guard let key = sy_objcKey(key: sy_gif_source_key) else { return nil }
        let obj = objc_getAssociatedObject(self, key);
        return obj as? SYGIFSourceModel
    }
    func sy_setGifSourceModel(model: SYGIFSourceModel?){
        guard let key = sy_objcKey(key: sy_gif_source_key) else { return }
        objc_setAssociatedObject(self, key, model, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func sy_gifInfoModel() -> SYGifInfoModel? {
        guard let key = sy_objcKey(key: sy_gif_info_key) else { return nil }
        let obj = objc_getAssociatedObject(self, key);
        return obj as? SYGifInfoModel
    }
    func sy_setGifInfoModel(infoModel: SYGifInfoModel?){
        guard let key = sy_objcKey(key: sy_gif_info_key) else { return }
        objc_setAssociatedObject(self, key, infoModel, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func sy_gifDisplayLink() -> CADisplayLink?{
        guard let key = sy_objcKey(key: sy_gif_display_key) else { return nil }
        return objc_getAssociatedObject(self, key) as? CADisplayLink
    }
    func sy_setDisplayLink(link: CADisplayLink?){
        guard let key = sy_objcKey(key: sy_gif_display_key) else { return  }
        objc_setAssociatedObject(self, key, link, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
        
    func sy_startGifAnimation(imgpath:String?,autoRepeat:Bool=false,endShowFirstImg:Bool=false){
        let sourceModel = SYGIFSourceModel.init(localpath: imgpath)
        let infoModel = SYGifInfoModel(autoRepeat: autoRepeat,endShowFirstImg: endShowFirstImg)
        self.sy_startGifAnimation(sourceModel: sourceModel,infoModel: infoModel)
    }
    
    func sy_startGifAnimation(sourceModel:SYGIFSourceModel,infoModel:SYGifInfoModel=SYGifInfoModel()){
        self.sy_setGifSourceModel(model: sourceModel)
        
        infoModel.state = .play
        self.sy_setGifInfoModel(infoModel: infoModel)
        
        sy_addDisplayLink()
    }
    
    func sy_endGifAnimation(){
        sy_removeDisplayLink()
        guard let infoModel = self.sy_gifInfoModel()else { return }
        infoModel.state = .origin
        if infoModel.endShowFirstImg {
            sy_showImg(at: 0,isReplaceTime: true)
        }
    }
    
    func sy_pauseGifAnimation() {
        guard let infoModel = self.sy_gifInfoModel()else { return }
        sy_removeDisplayLink()
        infoModel.state = .pause
    }
    
    func sy_resumeGifAnimation() {
        guard let infoModel = self.sy_gifInfoModel()else { return }
        sy_addDisplayLink()
        infoModel.state = .play
    }
    
    func sy_gifState() -> Int {
        guard let infoModel = self.sy_gifInfoModel()else {
            return SYGifInfoAnimationState.origin.rawValue
        }
        return infoModel.state.rawValue
    }
    
    @objc func sy_showGif(link:CADisplayLink){
        let time = link.duration
        sy_showImg(at: time,isReplaceTime: false)
    }
}


public extension UIImageView{    
    func sy_objcKey(key:String) -> UnsafePointer<Any>?{
        guard let objcKey = UnsafePointer<Any>.init(bitPattern: key.hashValue) else { return nil }
        return objcKey
    }
}

extension UIImageView{
    func sy_removeDisplayLink() {
        var link = self.sy_gifDisplayLink()
        if link == nil { return }
        link?.invalidate()
        link = nil
        self.sy_setDisplayLink(link: link)
    }
    
    func sy_addDisplayLink() {
        var link = self.sy_gifDisplayLink()
        link?.invalidate()
        link = nil
        
        let gifAction = #selector(sy_showGif(link:))
        let linkTarget = SYGifDisplayLinkProxy.initWithTarget(self, action:gifAction )
        link = CADisplayLink.init(target: linkTarget, selector: gifAction)
        link?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes);
        self.sy_setDisplayLink(link: link)
    }
    
    func sy_showImg(at time:TimeInterval,isReplaceTime:Bool) {
        guard let infoModel = self.sy_gifInfoModel() else { return }
        guard let sourceModel = self.sy_gifSourceModel() else { return }
        let totalTime = sourceModel.totalTime
        if totalTime < 0.15 {
            self.image = sourceModel.imgAtTime(time: 0)
            return
        }
        if isReplaceTime{
            infoModel.currentTime = time
        }else{
            infoModel.currentTime += time
        }
        if infoModel.currentTime > totalTime,infoModel.autoRepeat == false {
            return
        }
        var alterTime = infoModel.currentTime
        while alterTime > totalTime {
            alterTime -= totalTime
        }
        infoModel.currentTime = alterTime
        self.image = sourceModel.imgAtTime(time: infoModel.currentTime)
    }
}
