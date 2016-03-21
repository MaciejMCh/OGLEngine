//
//  OBJ.m
//  OGLEngine
//
//  Created by Maciej Chmielewski on 25.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import "OBJ.h"

@implementation OBJ

- (instancetype)initWithIndices:(GLIntArray *)indices
                      positions:(GLFloatArray *)positions
                         texels:(GLFloatArray *)texels
                        normals:(GLFloatArray *)normals {
    self = [super init];
    if (self) {
        self.indices = indices;
        self.positions = positions;
        self.texels = texels;
        self.normals = normals;
        [self calculateTangents];
    }
    return self;
}

- (void)calculateTangents {
    for (int i=0; i< self.indices.count; i+=3) {
        
        float v1[3] = {self.positions.data[self.indices.data[i + 0] + 0], self.positions.data[self.indices.data[i + 0] + 1], self.positions.data[self.indices.data[i + 0] + 2]};
        float v2[3] = {self.positions.data[self.indices.data[i + 1] + 0], self.positions.data[self.indices.data[i + 1] + 1], self.positions.data[self.indices.data[i + 1] + 2]};
        float v3[3] = {self.positions.data[self.indices.data[i + 2] + 0], self.positions.data[self.indices.data[i + 2] + 1], self.positions.data[self.indices.data[i + 2] + 2]};
        
        float t1[2] = {self.texels.data[self.indices.data[i + 0] + 0], self.texels.data[self.indices.data[i + 0] + 1]};
        float t2[2] = {self.texels.data[self.indices.data[i + 1] + 0], self.texels.data[self.indices.data[i + 1] + 1]};
        float t3[2] = {self.texels.data[self.indices.data[i + 2] + 0], self.texels.data[self.indices.data[i + 2] + 1]};
        
        float *tangents =
        [self processTriangle:v1
                           p2:v2
                           p3:v3
                           t1:t1
                           t2:t2
                           t3:t3];
        NSLog(@"kurwa");
    }
}

- (float *)processTriangle:(float *)p1 p2:(float *)p2 p3:(float *)p3 t1:(float *)t1 t2:(float *)t2 t3:(float *)t3 {
    float e1[3] = {p2[0] - p1[0], p2[1] - p1[1], p2[2] - p1[2]};
    float e2[3] = {p3[0] - p1[0], p3[1] - p1[1], p3[2] - p1[2]};
    float d1[3] = {t2[0] - t1[0], t2[1] - t1[1]};
    float d2[3] = {t3[0] - t1[0], t3[1] - t1[1]};
    
    GLfloat f = 1.0f / (d1[0] * d2[1] - d2[0] * d1[1]);
    
    float ta[3] = {
        f * (d2[1] * e1[0] - d1[1] * e2[0]),
        f * (d2[1] * e1[1] - d1[1] * e2[1]),
        f * (d2[1] * e1[2] - d1[1] * e2[2])
    };
    
    float bt[3] = {
        f * (-d2[0] * e1[0] + d1[0] * e2[0]),
        f * (-d2[0] * e1[1] + d1[0] * e2[1]),
        f * (-d2[0] * e1[2] + d1[0] * e2[2])
    };
    
    float length = sqrt((ta[0] * ta[0]) + (ta[1] * ta[1]) + (ta[2] * ta[2])) ;
    ta[0] = ta[0] / length;
    ta[1] = ta[1] / length;
    ta[2] = ta[2] / length;
    length = sqrt((bt[0] * bt[0]) + (bt[1] * bt[1]) + (bt[2] * bt[2])) ;
    bt[0] = bt[0] / length;
    bt[1] = bt[1] / length;
    bt[2] = bt[2] / length;
    
    float *result = malloc(6 * sizeof(float));
    result[0] = ta[0];
    result[1] = ta[1];
    result[2] = ta[2];
    result[3] = bt[0];
    result[4] = bt[1];
    result[5] = bt[2];
    
    return result;
}

@end


@implementation GLFloatArray

@end


@implementation GLIntArray

@end
