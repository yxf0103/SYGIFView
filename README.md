# SYGIFView

[![CI Status](https://img.shields.io/travis/yxfeng0103@hotmail.com/SYGIFView.svg?style=flat)](https://travis-ci.org/yxfeng0103@hotmail.com/SYGIFView)
[![Version](https://img.shields.io/cocoapods/v/SYGIFView.svg?style=flat)](https://cocoapods.org/pods/SYGIFView)
[![License](https://img.shields.io/cocoapods/l/SYGIFView.svg?style=flat)](https://cocoapods.org/pods/SYGIFView)
[![Platform](https://img.shields.io/cocoapods/p/SYGIFView.svg?style=flat)](https://cocoapods.org/pods/SYGIFView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SYGIFView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SYGIFView'
```

## Usage
swift
```
import SYGIFView

let imgView = UIImageView.init(frame: CGRect.init(x: 100, y: 100, width: 200, height: 160))
view.addSubview(imgView)
imgView.backgroundColor = UIColor.white
let path = Bundle.main.path(forResource: "demo.gif", ofType: nil)

// start animate
//localpath
imgView.sy_startGifAnimation(imgpath: path,autoRepeat: true)
//network url
webimgView.sy_startGifAnimation(url:url, autoRepeat: true)

//end animate
imgView.sy_endGifAnimation()
```

oc
```
//start animation

NSString *path = [[NSBundle mainBundle] pathForResource:@"demo.gif" ofType:nil];
UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 500, 200, 160)];
[imgView sy_startGifAnimationWithImgpath:path autoRepeat:YES];
[view addSubview:imgView];
    
//end animation
[imgView sy_endGifAnimation];    
```


## Author

yxfeng0103@hotmail.com, ssi-yanxf@dfmc.com.cn

## License

SYGIFView is available under the MIT license. See the LICENSE file for more info.
