//
//  StaticGeometryModel.m
//  jj
//
//  Created by Maciej Chmielewski on 14.02.2016.
//  Copyright © 2016 AppUnite. All rights reserved.
//

#import "StaticGeometryModel.h"

@interface StaticGeometryModel ()

@property (nonatomic, assign) GLKMatrix4 staticModelMatrix;

@end

@implementation StaticGeometryModel

- (instancetype)initWithModelMatrix:(GLKMatrix4)modelMatrix {
    self = [super init];
    if (self) {
        self.staticModelMatrix = modelMatrix;
    }
    return self;
}

- (GLKMatrix4)modelMatrix {
    return self.staticModelMatrix;
}

@end
