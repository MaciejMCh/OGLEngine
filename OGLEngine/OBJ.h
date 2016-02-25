//
//  OBJ.h
//  OGLEngine
//
//  Created by Maciej Chmielewski on 25.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>

@interface GLFloatArray : NSObject

@property (nonatomic, assign) GLfloat *data;
@property (nonatomic, assign) unsigned int count;

@end


@interface GLIntArray : NSObject

@property (nonatomic, assign) GLuint *data;
@property (nonatomic, assign) unsigned int count;

@end


@interface OBJ : NSObject

@property (nonatomic, strong) GLIntArray *indices;
@property (nonatomic, strong) GLFloatArray *positions;

- (instancetype)initWithIndices:(GLIntArray *)indices positions:(GLFloatArray *)positions;

@end
