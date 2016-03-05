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
