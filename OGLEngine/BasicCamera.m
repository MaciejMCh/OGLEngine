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

- (instancetype)initWithPosition:(GLKVector3)position orientation:(GLKVector3)orientation {
    self = [super init];
    if (self) {
        self.position = position;
        self.orientation = orientation;
        
        float aspect = fabs([UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height);
        self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    }
    return self;
}

- (GLKVector3)cameraPosition {
    return self.position;
}

- (GLKMatrix4)viewProjectionMatrix {
    GLKMatrix4 viewProjectionMatrix = self.projectionMatrix;
    viewProjectionMatrix = GLKMatrix4Rotate(viewProjectionMatrix, self.orientation.x, 1, 0, 0);
    viewProjectionMatrix = GLKMatrix4Rotate(viewProjectionMatrix, self.orientation.y, 0, 1, 0);
    viewProjectionMatrix = GLKMatrix4Rotate(viewProjectionMatrix, self.orientation.z, 0, 0, 1);
    viewProjectionMatrix = GLKMatrix4Translate(viewProjectionMatrix, self.position.x, self.position.y, self.position.z);
    return viewProjectionMatrix;
}

@end


@implementation TestCamera

- (GLKMatrix4)viewProjectionMatrix {
    GLKMatrix4 projectionMatrix = GLKMatrix4Rotate(self.projectionMatrix, self.position.x / 10, 0, 1, 0);
    projectionMatrix = GLKMatrix4Translate(projectionMatrix, self.position.x, self.position.y, self.position.z);
    return projectionMatrix;
}

@end