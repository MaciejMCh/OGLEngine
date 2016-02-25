//
//  BasicCamera.h
//  jj
//
//  Created by Maciej Chmielewski on 14.02.2016.
//  Copyright © 2016 AppUnite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Camera.h"

@interface BasicCamera : NSObject<Camera>

@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic, assign) GLKVector3 eyeNormal;

- (instancetype)initWithPosition:(GLKVector3)position eyeNormal:(GLKVector3)eyeNormal;

@end
