//
//  SpinningGeometryModel.m
//  jj
//
//  Created by Maciej Chmielewski on 17.02.2016.
//  Copyright © 2016 AppUnite. All rights reserved.
//

#import "SpinningGeometryModel.h"

@interface SpinningGeometryModel ()

@property (nonatomic, assign) GLKMatrix4 translation;

@end

@implementation SpinningGeometryModel

- (instancetype)initWithPosition:(GLKVector3)position {
    self = [super init];
    if (self) {
        self.translation = GLKMatrix4MakeTranslation(position.x, position.y, position.z);
    }
    return self;
}

- (GLKMatrix4)modelMatrix {
    return GLKMatrix4Rotate(self.translation, CACurrentMediaTime(), 0.5, 1, 0.25);
}

@end
