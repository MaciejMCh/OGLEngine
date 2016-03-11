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
    self = [self init];
    if (self) {
        self.position = position;
        self.orientation = orientation;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        float aspect = fabs([UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height);
        self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    }
    return self;
}

- (GLKVector3)cameraPosition {
    return self.position;
}

- (GLKMatrix4)viewMatrix {
    GLKVector3 orientation = self.orientation;
    GLKVector3 position = self.position;
    GLKMatrix4 viewProjectionMatrix = GLKMatrix4Identity;
    viewProjectionMatrix = GLKMatrix4Rotate(viewProjectionMatrix, orientation.x, 1, 0, 0);
    viewProjectionMatrix = GLKMatrix4Rotate(viewProjectionMatrix, orientation.y, 0, 1, 0);
    viewProjectionMatrix = GLKMatrix4Rotate(viewProjectionMatrix, orientation.z, 0, 0, 1);
    viewProjectionMatrix = GLKMatrix4Translate(viewProjectionMatrix, position.x, position.y, position.z);
    return viewProjectionMatrix;
}

@end
