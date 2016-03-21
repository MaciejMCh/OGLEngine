////
////  OBJ+samples.m
////  OGLEngine
////
////  Created by Maciej Chmielewski on 25.02.2016.
////  Copyright © 2016 MaciejCh. All rights reserved.
////
//
//#import "OBJ+samples.h"
//#import "OGLEngine-Swift.h"
//
//@implementation OBJ (samples)
//
//+ (OBJ *)square {
//    GLfloat Vertices[] = {
//        10000, -10000, 0,
//        10000, 10000, 0,
//        -10000, 10000, 0,
//        -10000, -10000, 0
//    };
//    
//    GLuint Indices[] = {
//        0, 1, 2,
//        2, 3, 0
//    };
//    
//    GLuint Texels[] = {
//        0,0,
//        0,1,
//        1,1,
//        1,0
//    };
//    
//    GLuint Normals[] = {
//        0,0,1,
//        0,0,1,
//        0,0,1,
//        0,0,1
//    };
//    
//    
//    GLFloatArray *positions = [GLFloatArray new];
//    positions.count = 12;
//    positions.data = (__bridge NSArray<NSNumber *> * _Nonnull)(malloc(12 * sizeof(GLfloat)));
//    for (int i=0; i<12; i++) {
//        positions.data[i] = Vertices[i];
//    }
//    
//    GLIntArray *indices = [GLIntArray new];
//    indices.count = 6;
//    indices.data = malloc(6 * sizeof(GLuint));
//    for (int i=0; i<6; i++) {
//        indices.data[i] = Indices[i];
//    }
//    
//    GLFloatArray *texels = [GLFloatArray new];
//    texels.count = 8;
//    texels.data = malloc(8 * sizeof(GLfloat));
//    for (int i=0; i<8; i++) {
//        texels.data[i] = Texels[i];
//    }
//    
//    GLFloatArray *normals = [GLFloatArray new];
//    normals.count = 12;
//    normals.data = malloc(12 * sizeof(GLfloat));
//    for (int i=0; i<12; i++) {
//        normals.data[i] = Normals[i];
//    }
//    
//    OBJ *obj = [[OBJ alloc] initWithIndices:indices positions:positions texels:texels normals:normals];
//    return obj;
//}
//
//@end
