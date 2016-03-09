//
//  RemoteControllerModels.h
//  OGLEngine
//
//  Created by Maciej Chmielewski on 09.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteMouse : NSObject

@property (nonatomic, assign) float xPosition;
@property (nonatomic, assign) float yPosition;

+ (RemoteMouse *)mouseWithMessage:(NSString *)message;

@end


typedef NS_ENUM(NSUInteger, KeyState) {
    KeyStateDown,
    KeyStateUp
};

@interface RemoteKey : NSObject

@property (nonatomic, assign) unsigned int key;
@property (nonatomic, assign) KeyState keyState;

+ (RemoteKey *)keyWithMessage:(NSString *)message;

@end