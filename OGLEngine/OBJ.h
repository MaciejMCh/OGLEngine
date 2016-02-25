//
//  OBJ.h
//  OGLEngine
//
//  Created by Maciej Chmielewski on 25.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>

struct GLFloatArray {
    GLfloat *data;
    unsigned int count;
};

struct GLIntArray {
    GLuint *data;
    unsigned int count;
};

@interface OBJ : NSObject

@property (nonatomic, assign) struct GLIntArray indices;
@property (nonatomic, assign) struct GLFloatArray positions;

- (instancetype)initWithIndices:(struct GLIntArray)indices positions:(struct GLFloatArray)positions;

@end
