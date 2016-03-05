//
//  FocusingCamera.m
//  OGLEngine
//
//  Created by Maciej Chmielewski on 05.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import "FocusingCamera.h"

@interface FocusingCamera ()

@end

@implementation FocusingCamera

- (instancetype)initWithPosition:(GLKVector3)position hAngle:(float)hAngle vAngle:(float)vAngle distance:(float)distance {
    self = [super init];
    if (self) {
        self.position = position;
        self.hAngle = hAngle;
        self.vAngle = vAngle;
        self.distance = distance;
    }
    return self;
}

- (GLKVector3)position {
    return GLKVector3Make(
                          self.distance * cos(self.hAngle) * sin(self.vAngle),
                          self.distance * sin(self.hAngle) * sin(self.vAngle),
                          self.distance * cos(self.vAngle)
                          );
}

- (GLKVector3)orientation {
    return GLKVector3Make(
                          M_PI - self.vAngle,
                          0,
                          -self.hAngle - M_PI_2
                          );
}

@end
