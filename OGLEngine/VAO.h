//
//  VAO.h
//  OGLEngine
//
//  Created by Maciej Chmielewski on 25.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBJ.h"

typedef NS_ENUM(NSUInteger, VboIndex) {
    VboIndexPositions = 0,
    VboIndexTexels,
    VboIndexNormals,
    VbosCount
};

@interface VAO : NSObject

@property (nonatomic, assign) unsigned int vertexCount;
@property (nonatomic, assign) GLuint vaoGLName;
@property (nonatomic, assign) GLuint indicesVboGLName;
@property (nonatomic, assign) GLuint positionsVboGLName;
@property (nonatomic, assign) GLuint texelsVboGLName;
@property (nonatomic, assign) GLuint normalsVboGLName;

- (instancetype)initWithOBJ:(OBJ *)obj;

@end
