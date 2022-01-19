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
        
//        imgView.sy_endGifAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

