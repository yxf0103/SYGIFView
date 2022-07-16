//
//  ViewController.swift
//  SYGIFView
//
//  Created by yxfeng0103@hotmail.com on 01/15/2022.
//  Copyright (c) 2022 yxfeng0103@hotmail.com. All rights reserved.
//

import UIKit
import SYGIFView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
        
        let imgView = UIImageView.init(frame: CGRect.init(x: 100, y: 100, width: 200, height: 160))
        view.addSubview(imgView)
        imgView.backgroundColor = UIColor.white
        let path = Bundle.main.path(forResource: "demo.gif", ofType: nil)
        imgView.sy_startGifAnimation(imgpath: path,autoRepeat: true)
        addTapGestureToImgView(imgView: imgView,action: #selector(tapPauseResumeImgview(tap:)))
        
        let webimgView = UIImageView.init(frame: CGRect.init(x: 100, y: 300, width: 200, height: 160))
        view.addSubview(webimgView)
        webimgView.backgroundColor = UIColor.white
        webimgView.sy_startGifAnimation(url:
                                        
                                        "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F018d4d56e10ebc32f875520f5e890e.gif&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1645175434&t=1c58627c81de607308af33727a2f60bc", autoRepeat: true,endShowFirstImage: true)
        
//        imgView.sy_endGifAnimation()
        
        let ocImgView = OCDemo.showImgOnview(self.view)
        addTapGestureToImgView(imgView: ocImgView, action: #selector(tapPlayEndImgview(tap:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTapGestureToImgView(imgView:UIImageView,action:Selector) {
        imgView.isUserInteractionEnabled = true;
        let tap = UITapGestureRecognizer.init(target: self, action: action)
        imgView.addGestureRecognizer(tap)
    }
    
    @objc func tapPauseResumeImgview(tap:UITapGestureRecognizer) {
        guard let imgview = tap.view as? UIImageView else{
            return
        }
        let state = imgview.sy_gifState()
        if state == 1 {
            imgview.sy_pauseGifAnimation()
        }
        if state == 2 {
            imgview.sy_resumeGifAnimation()
        }
    }
    
    @objc func tapPlayEndImgview(tap:UITapGestureRecognizer) {
        guard let imgview = tap.view as? UIImageView else{
            return
        }
        let state = imgview.sy_gifState()
        if state == 0 {
            let path = Bundle.main.path(forResource: "demo.gif", ofType: nil)
            imgview.sy_startGifAnimation(imgpath: path,autoRepeat: true,endShowFirstImg: true)
        }
        if state == 1 {
            imgview.sy_endGifAnimation()
        }
    }
    
}

