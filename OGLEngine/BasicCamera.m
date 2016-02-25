//
//  BasicCamera.m
//  jj
//
//  Created by Maciej Chmielewski on 14.02.2016.
//  Copyright © 2016 AppUnite. All rights reserved.
//

#import "BasicCamera.h"

@interface BasicCamera ()

@property (nonatomic, assign) GLKMatrix4 projectionMatrix;

@end

@implementation BasicCamera

- (instancetype)initWithPosition:(GLKVector3)position {
    self = [super init];
    if (self) {
        self.position = position;
        
        float aspect = fabs([UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height);
        self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    }
    return self;
}

- (GLKVector3)cameraPosition {
    return self.position;
}

- (GLKMatrix4)viewProjectionMatrix {
    return GLKMatrix4Translate(self.projectionMatrix, self.position.x, self.position.y, self.position.z);
}

@end


@implementation TestCamera

- (GLKMatrix4)viewProjectionMatrix {
    GLKMatrix4 projectionMatrix = GLKMatrix4Rotate(self.projectionMatrix, self.position.x / 10, 0, 1, 0);
    projectionMatrix = GLKMatrix4Translate(projectionMatrix, self.position.x, self.position.y, self.position.z);
    return projectionMatrix;
}

@end