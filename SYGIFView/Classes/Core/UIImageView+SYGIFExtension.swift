//
//  UIImageView+SYGIFExtension.swift
//  SYGIFView
//
//  Created by yxf on 2022/1/15.
//

import Foundation

let sy_gif_key = "sy_gifModel_key"
let sy_gif_display_key = "sy_gif_display_key"
let sy_gif_time_key = "sy_gif_time_key"

public extension UIImageView{
    
    func sy_objcKey(key:String) -> UnsafePointer<Any>?{
        guard let objcKey = UnsafePointer<Any>.init(bitPattern: key.hashValue) else { return nil }
        return objcKey
    }
    
    func sy_gifModel() -> SYGIFModel? {
        guard let key = sy_objcKey(key: sy_gif_key) else { return nil }
        let obj = objc_getAssociatedObject(self, key);
        return obj as? SYGIFModel
    }
    func sy_setGifModel(model: SYGIFModel?){
        guard let key = sy_objcKey(key: sy_gif_key) else { return }
        objc_setAssociatedObject(self, key, model, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func sy_gifDisplayLink() -> CADisplayLink?{
        guard let key = sy_objcKey(key: sy_gif_display_key) else { return nil }
        return objc_getAssociatedObject(self, key) as? CADisplayLink
    }
    
    func sy_setDisplayLink(link: CADisplayLink?){
        guard let key = sy_objcKey(key: sy_gif_display_key) else { return  }
        objc_setAssociatedObject(self, key, link, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func sy_setCurrentTime(time: TimeInterval){
        guard let key = sy_objcKey(key: sy_gif_time_key) else { return  }
        objc_setAssociatedObject(self, key, time, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    func sy_gifCurrentTime() -> TimeInterval{
        guard let key = sy_objcKey(key: sy_gif_time_key) else { return 0 }
        return objc_getAssociatedObject(self, key) as? TimeInterval ?? 0
    }
        
    func sy_startGifAnimation(imgpath:String?,autoRepeat:Bool=false){
        let model = SYGIFModel.init(localpath: imgpath)
        model.autoRepeat = autoRepeat
        self.sy_startGifAnimation(model: model)
    }
    
    func sy_startGifAnimation(model:SYGIFModel){
        self.sy_setGifModel(model: model)
        self.sy_setCurrentTime(time: 0)
        
        var link = self.sy_gifDisplayLink()
        link?.invalidate()
        link = nil
        
        link = CADisplayLink.init(target: self, selector: #selector(sy_showGif))
        link?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes);
        self.sy_setDisplayLink(link: link)
    }
    
    func sy_endGifAnimation(){
        var link = self.sy_gifDisplayLink()
        if link == nil { return }
        link?.invalidate()
        link = nil
        self.sy_setDisplayLink(link: link)
    }
    
    @objc func sy_showGif(link:CADisplayLink){
        var time = link.duration
        time += self.sy_gifCurrentTime()
        self.sy_setCurrentTime(time: time)
        let model = self.sy_gifModel()
        self.image = model?.imgAtTime(time: time)
    }
}
