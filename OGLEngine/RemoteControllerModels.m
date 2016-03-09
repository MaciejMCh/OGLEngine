//
//  RemoteControllerModels.m
//  OGLEngine
//
//  Created by Maciej Chmielewski on 09.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import "RemoteControllerModels.h"

@implementation RemoteMouse

+ (RemoteMouse *)mouseWithMessage:(NSString *)message {
    NSArray<NSString *> *components = [message componentsSeparatedByString:@" "];
    NSAssert(components.count == 3, @"format is: m f f");
    
    RemoteMouse *mouse = [RemoteMouse new];
    mouse.xPosition = [components[1] floatValue];
    mouse.yPosition = [components[2] floatValue];
    
    return mouse;
}

@end


@implementation RemoteKey

+ (RemoteKey *)keyWithMessage:(NSString *)message {
    NSArray<NSString *> *components = [message componentsSeparatedByString:@" "];
    NSAssert(components.count == 2, @"format is: d/u d");
    
    RemoteKey *key = [RemoteKey new];
    key.keyState = [components[0] isEqualToString:@"d"] ? KeyStateDown : KeyStateUp;
    key.key = [components[1] integerValue];
    
    return key;
}

@end