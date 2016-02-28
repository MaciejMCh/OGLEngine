//
//  OBJLoader.h
//  jj
//
//  Created by Maciej Chmielewski on 16.02.2016.
//  Copyright © 2016 AppUnite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>
#import "OBJ.h"

typedef struct OBJInfo {
    int vertices;
    int positions;
    int texels;
    int normals;
    int faces;
}
OBJInfo;

@class OBJLoadingResult, StrideData, StrideCollection;

@interface OBJLoader : NSObject

+ (OBJ *)objFromFileNamed:(NSString *)fileName;
+ (OBJLoadingResult *)loadOBJNamed:(NSString *)name;
+ (StrideCollection *)strideDataFromOBJLoadingResult:(OBJLoadingResult *)objLoadingResult;
+ (OBJ *)objFromStrideCollection:(StrideCollection *)strideCollection objLoadingResult:(OBJLoadingResult *)objLoadingResult;

@end


@interface OBJLoadingResult : NSObject

@property (nonatomic, assign, readonly) OBJInfo objInfo;
@property (nonatomic, assign, readonly) GLfloat **positions;
@property (nonatomic, assign, readonly) GLfloat **texels;
@property (nonatomic, assign, readonly) GLfloat **normals;
@property (nonatomic, assign, readonly) GLint **faces;

@end


@interface StrideData : NSObject

@property (nonatomic, assign) NSUInteger positionIndex;
@property (nonatomic, assign) NSUInteger texelIndex;
@property (nonatomic, assign) NSUInteger normalIndex;

@property (nonatomic, assign) GLfloat *positions;
@property (nonatomic, assign) GLfloat *texels;
@property (nonatomic, assign) GLfloat *normals;

- (instancetype)initWithPositionIndex:(NSUInteger)positionIndex
                           texelIndex:(NSUInteger)texelIndex
                          normalIndex:(NSUInteger)normalIndex
                            positions:(GLfloat **)positions
                               texels:(GLfloat **)texels
                              normals:(GLfloat **)normals;
@end


@interface StrideCollection : NSObject

- (void)addObject:(StrideData *)stride;

@property (nonatomic, strong) NSMutableArray<StrideData *> *array;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *indices;

@end