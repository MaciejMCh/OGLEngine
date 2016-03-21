//
//  FocusingCamera.h
//  OGLEngine
//
//  Created by Maciej Chmielewski on 05.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

//#import "BasicCamera.h"
#import "OGLEngine-Swift.h"

//@interface FocusingCamera : BasicCamera
@interface FocusingCamera : NSObject

@property (nonatomic, assign) float vAngle;
@property (nonatomic, assign) float hAngle;
@property (nonatomic, assign) float distance;

- (instancetype)initWithPosition:(GLKVector3)position hAngle:(float)hAngle vAngle:(float)vAngle distance:(float)distance;

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer;

@end
