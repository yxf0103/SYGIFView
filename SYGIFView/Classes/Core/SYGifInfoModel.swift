//
//  SYGifInfoModel.swift
//  SYGIFView
//
//  Created by yxf on 2022/7/16.
//

import UIKit

public enum SYGifInfoAnimationState : Int {
    case origin = 0
    case play
    case pause
}

open class SYGifInfoModel: NSObject {
    var autoRepeat = false
    var currentTime : TimeInterval = 0
    var endShowFirstImg = false
    var state = SYGifInfoAnimationState.origin
    
    var gifProxy : SYGifDisplayLinkProxy?
    
    init(autoRepeat:Bool=false,endShowFirstImg:Bool=false) {
        self.autoRepeat = autoRepeat
        self.endShowFirstImg = endShowFirstImg
    }
    public override init() {
        
    }
    
    deinit {
        gifProxy?.displayLink?.invalidate()
    }
}
