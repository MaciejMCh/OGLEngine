//
//  BasicCamera.m
//  jj
//
//  Created by Maciej Chmielewski on 14.02.2016.
//  Copyright © 2016 AppUnite. All rights reserved.
//

#import "BasicCamera.h"

@implementation BasicCamera

- (instancetype)initWithPosition:(GLKVector3)position eyeNormal:(GLKVector3)eyeNormal {
    self = [super init];
    if (self) {
        self.position = position;
        self.eyeNormal = eyeNormal;
    }
    return self;
}

- (GLKVector3)cameraPosition {
    return self.position;
}

- (GLKVector3)cameraEyeNormal {
    return self.cameraEyeNormal;
}

- (GLKMatrix4)projectionMatrix {
    float aspect = fabs([UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
//    projectionMatrix = GLKMatrix4Rotate(projectionMatrix, 1.0, 0, 0, 0);
    projectionMatrix = GLKMatrix4Rotate(projectionMatrix, self.position.x / 10, 0, 1, 0);
    projectionMatrix = GLKMatrix4Translate(projectionMatrix, self.position.x, self.position.y, self.position.z);
    
    
    
    return projectionMatrix;
}

@end
