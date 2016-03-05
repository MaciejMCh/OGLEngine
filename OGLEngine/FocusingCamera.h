//
//  FocusingCamera.h
//  OGLEngine
//
//  Created by Maciej Chmielewski on 05.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import "BasicCamera.h"

@interface FocusingCamera : BasicCamera

@property (nonatomic, assign) float vAngle;
@property (nonatomic, assign) float hAngle;
@property (nonatomic, assign) float distance;

@end
