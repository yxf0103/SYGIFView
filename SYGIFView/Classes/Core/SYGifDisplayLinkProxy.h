//
//  SYGifDisplayLinkProxy.h
//  SYGIFView
//
//  Created by yxf on 2022/7/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYGifDisplayLinkProxy : NSProxy

@property (nonatomic,weak)CADisplayLink *displayLink;

+(instancetype)initWithTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
