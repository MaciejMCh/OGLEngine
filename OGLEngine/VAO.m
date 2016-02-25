//
//  VAO.m
//  OGLEngine
//
//  Created by Maciej Chmielewski on 25.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import "VAO.h"

@implementation VAO

- (instancetype)initWithOBJ:(OBJ *)obj {
    self = [super init];
    if (self) {
        
        GLuint vaoGLName = 0;
        glGenVertexArraysOES(1, &vaoGLName);
        glBindVertexArrayOES(vaoGLName);
        self.vaoGLName = vaoGLName;

        GLuint indicesVboGLName = 0;
        glGenBuffers(1, &indicesVboGLName);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indicesVboGLName);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, obj.indices.count * sizeof(GLuint), obj.indices.data, GL_STATIC_DRAW);
        
        self.positionsVboGLName = [self generateVboAtIndex:Positions data:obj.positions perVertexCount:3];
        
        glBindVertexArrayOES(0);
    }
    return self;
}

- (GLuint)generateVboAtIndex:(VboIndex)index data:(GLFloatArray *)data perVertexCount:(unsigned int)perVertexCount {
    GLuint vboGLName;
    glGenBuffers(1, &vboGLName);
    glBindBuffer(GL_ARRAY_BUFFER, vboGLName);
    glBufferData(GL_ARRAY_BUFFER, data.count * sizeof(GLfloat), data.data, GL_STATIC_DRAW);
    glVertexAttribPointer(0, perVertexCount, GL_FLOAT, GL_FALSE, 0, 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    return vboGLName;
}

@end
