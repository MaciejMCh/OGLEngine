//
//  FocusingCamera.m
//  OGLEngine
//
//  Created by Maciej Chmielewski on 05.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import "FocusingCamera.h"

@implementation FocusingCamera

- (GLKMatrix4)viewProjectionMatrix {
    
    self.position = GLKVector3Make(self.distance * sinf(self.hAngle), self.distance * cosf(self.hAngle), 0);
    
    
    return [super viewProjectionMatrix];
}

@end
