//
//  OBJLoader.h
//  jj
//
//  Created by Maciej Chmielewski on 16.02.2016.
//  Copyright © 2016 AppUnite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>

typedef struct OBJInfo {
    int vertices;
    int positions;
    int texels;
    int normals;
    int faces;
}
OBJInfo;

@class OBJLoadingResult;

@interface OBJLoader : NSObject

+ (OBJLoadingResult *)loadOBJNamed:(NSString *)name;

@end


@interface OBJLoadingResult : NSObject

@property (nonatomic, assign, readonly) OBJInfo objInfo;
@property (nonatomic, assign, readonly) GLfloat *positions;
@property (nonatomic, assign, readonly) GLfloat *texels;
@property (nonatomic, assign, readonly) GLfloat *normals;
@property (nonatomic, assign, readonly) GLuint *faces;

@end