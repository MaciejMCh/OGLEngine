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

@end


@interface KeyToggle : NSObject

@property (nonatomic, assign) CFTimeInterval beginInterval;
@property (nonatomic, strong) RemoteKey *key;

+ (KeyToggle *)keyToggleWithKey:(RemoteKey *)key beginInterval:(CFTimeInterval)beginInterval;

@end