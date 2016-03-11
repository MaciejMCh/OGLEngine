//
//  RemoteControlledCamera.h
//  OGLEngine
//
//  Created by Maciej Chmielewski on 09.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import "BasicCamera.h"
#import "RemoteController.h"

@interface RemoteControlledCamera : BasicCamera

@property (nonatomic, assign) float xOffset;
@property (nonatomic, assign) float yOffset;
@property (nonatomic, assign) float zOffset;

@property (nonatomic, assign) float xMouse;
@property (nonatomic, assign) float yMouse;

@end


@interface KeyToggle : NSObject

@property (nonatomic, assign) CFTimeInterval beginInterval;
@property (nonatomic, strong) RemoteKey *key;

+ (KeyToggle *)keyToggleWithKey:(RemoteKey *)key beginInterval:(CFTimeInterval)beginInterval;

@end