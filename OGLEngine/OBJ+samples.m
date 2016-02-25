//
//  OBJ+samples.m
//  OGLEngine
//
//  Created by Maciej Chmielewski on 25.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import "OBJ+samples.h"

@implementation OBJ (samples)

+ (OBJ *)square {
    GLfloat Vertices[] = {
        .5, -.5, 0,
        .5, .5, 0,
        -.5, .5, 0,
        -.5, -.5, 0
    };
    
    GLuint Indices[] = {
        0, 1, 2,
        2, 3, 0
    };
    
    GLFloatArray *positions = [GLFloatArray new];
    positions.count = 12;
    positions.data = malloc(12 * sizeof(GLfloat));
    for (int i=0; i<12; i++) {
        positions.data[i] = Vertices[i];
    }
    
    GLIntArray *indices = [GLIntArray new];
    indices.count = 6;
    indices.data = malloc(6 * sizeof(GLuint));
    for (int i=0; i<6; i++) {
        indices.data[i] = Indices[i];
    }
    
    OBJ *obj = [[OBJ alloc] initWithIndices:indices positions:positions];
    return obj;
}

@end
