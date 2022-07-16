//
//  SYGifDisplayLinkProxy.m
//  SYGIFView
//
//  Created by yxf on 2022/7/16.
//

#import "SYGifDisplayLinkProxy.h"

@interface SYGifDisplayLinkProxy ()

@property (nonatomic,weak)id target;

@property (nonatomic,assign)SEL action;

@end

@implementation SYGifDisplayLinkProxy

+(instancetype)initWithTarget:(id)target action:(SEL)action{
    SYGifDisplayLinkProxy *proxy = [SYGifDisplayLinkProxy alloc];
    proxy.target = target;
    proxy.action = action;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    if (sel == _action && !!_target) {
        return [_target methodSignatureForSelector:sel];
    }
    return [super methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    if (invocation.selector == _action && !!_target) {
        [invocation invokeWithTarget:_target];
        return;
    }
    [super forwardInvocation:invocation];
}

@end
