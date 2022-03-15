//
//  OCDemo.m
//  SYGIFView_Example
//
//  Created by yxf on 2022/3/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

#import "OCDemo.h"
#import "SYGIFView_Example-Swift.h"
#import "SYGIFView_Example-Bridging-Header.h"


@implementation OCDemo

+(UIImageView *)showImgOnview:(id)view{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo.gif" ofType:nil];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 500, 200, 160)];
    [imgView sy_startGifAnimationWithImgpath:path autoRepeat:YES];
    [view addSubview:imgView];
    return imgView;
}

+(void)endImgview:(UIImageView *)view{
    [view sy_endGifAnimation];
}

@end
