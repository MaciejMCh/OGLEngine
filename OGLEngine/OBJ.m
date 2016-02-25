//
//  OBJ.m
//  OGLEngine
//
//  Created by Maciej Chmielewski on 25.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import "OBJ.h"

@implementation OBJ

- (instancetype)initWithIndices:(GLIntArray *)indices positions:(GLFloatArray *)positions {
    self = [super init];
    if (self) {
        self.indices = indices;
        self.positions = positions;
    }
    return self;
}

@end


@implementation GLFloatArray

@end


@implementation GLIntArray

@end
