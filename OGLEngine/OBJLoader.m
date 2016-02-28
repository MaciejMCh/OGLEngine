//
//  OBJLoader.m
//  jj
//
//  Created by Maciej Chmielewski on 16.02.2016.
//  Copyright © 2016 AppUnite. All rights reserved.
//

#import "OBJLoader.h"

@interface OBJLoadingResult ()

@property (nonatomic, assign, readwrite) OBJInfo objInfo;
@property (nonatomic, assign, readwrite) GLfloat **positions;
@property (nonatomic, assign, readwrite) GLfloat **texels;
@property (nonatomic, assign, readwrite) GLfloat **normals;
@property (nonatomic, assign, readwrite) GLint **faces;

@end

@implementation OBJLoadingResult

@end


@implementation OBJLoader

+ (OBJ *)objFromFileNamed:(NSString *)fileName {
    OBJLoadingResult *result = [OBJLoader loadOBJNamed:fileName];
    return [OBJLoader objFromStrideCollection:[OBJLoader strideDataFromOBJLoadingResult:result]
                             objLoadingResult:result];
}

+ (OBJ *)objFromStrideCollection:(StrideCollection *)strideCollection objLoadingResult:(OBJLoadingResult *)objLoadingResult {
    // Indices
    GLuint *indices = malloc(strideCollection.indices.count * sizeof(GLuint));
    for (int i=0; i<strideCollection.indices.count; i++) {
        indices[i] = [strideCollection.indices[i] unsignedIntValue];
    }
    GLIntArray *indicesArray = [GLIntArray new];
    indicesArray.data = indices;
    indicesArray.count = strideCollection.indices.count;
    
    // Vertex data
    GLfloat *positions = malloc(strideCollection.array.count * 3 * sizeof(GLfloat));
    GLfloat *texels = malloc(strideCollection.array.count * 2 * sizeof(GLfloat));
    GLfloat *normals = malloc(strideCollection.array.count * 3 * sizeof(GLfloat));
    OBJInfo structIterator = {0};
    for (StrideData *stride in strideCollection.array) {
        positions[structIterator.positions ++] = stride.positions[0];
        positions[structIterator.positions ++] = stride.positions[1];
        positions[structIterator.positions ++] = stride.positions[2];
        
        texels[structIterator.texels ++] = stride.texels[0];
        texels[structIterator.texels ++] = stride.texels[1];
        
        normals[structIterator.normals ++] = stride.normals[0];
        normals[structIterator.normals ++] = stride.normals[1];
        normals[structIterator.normals ++] = stride.normals[2];
    }
    
    GLFloatArray *positionsArray = [GLFloatArray new];
    positionsArray.data = positions;
    positionsArray.count = structIterator.positions;
    
    GLFloatArray *texelsArray = [GLFloatArray new];
    texelsArray.data = texels;
    texelsArray.count = structIterator.texels;
    
    GLFloatArray *normalsArray = [GLFloatArray new];
    normalsArray.data = normals;
    positionsArray.count = structIterator.positions;
    
    return [[OBJ alloc] initWithIndices:indicesArray
                              positions:positionsArray
                                 texels:texelsArray
                                normals:normalsArray];
}

+ (StrideCollection *)strideDataFromOBJLoadingResult:(OBJLoadingResult *)objLoadingResult {
    StrideCollection *strides = [StrideCollection new];
    
    for (int i=0; i<objLoadingResult.objInfo.faces; i++) {
        [strides addObject:[[StrideData alloc] initWithPositionIndex:objLoadingResult.faces[i][0]
                                                          texelIndex:objLoadingResult.faces[i][1]
                                                         normalIndex:objLoadingResult.faces[i][2]
                                                           positions:objLoadingResult.positions
                                                              texels:objLoadingResult.texels
                                                             normals:objLoadingResult.normals]];
        [strides addObject:[[StrideData alloc] initWithPositionIndex:objLoadingResult.faces[i][3]
                                                          texelIndex:objLoadingResult.faces[i][4]
                                                         normalIndex:objLoadingResult.faces[i][5]
                                                           positions:objLoadingResult.positions
                                                              texels:objLoadingResult.texels
                                                             normals:objLoadingResult.normals]];
        [strides addObject:[[StrideData alloc] initWithPositionIndex:objLoadingResult.faces[i][6]
                                                          texelIndex:objLoadingResult.faces[i][7]
                                                         normalIndex:objLoadingResult.faces[i][8]
                                                           positions:objLoadingResult.positions
                                                              texels:objLoadingResult.texels
                                                             normals:objLoadingResult.normals]];
    }
    return strides;
}

+ (OBJLoadingResult *)loadOBJNamed:(NSString *)name {
    OBJLoadingResult *result = [OBJLoadingResult new];
    
    // read file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"obj"];
    NSString *payload = [NSString stringWithContentsOfFile:filePath];
    NSArray<NSString *> *lines = [payload componentsSeparatedByString:@"\n"];
    
    // read info
    OBJInfo objInfo = {0};
    for (NSString *line in lines) {
        if ([line hasPrefix:@"v "]) {
            objInfo.positions ++;
        } else if ([line hasPrefix:@"vn"]) {
            objInfo.normals ++;
        } else if ([line hasPrefix:@"vt"]) {
            objInfo.texels ++;
        } else if ([line hasPrefix:@"f "]) {
            objInfo.faces ++;
        }
    }
    objInfo.vertices = objInfo.faces * 3;
    result.objInfo = objInfo;
    
    // init arrays
    result.positions = malloc(objInfo.positions * sizeof(GLfloat *));
    for (int i=0; i<=objInfo.positions - 1; i++) {
        result.positions[i] = malloc(3 * sizeof(GLfloat));
    }
    result.texels = malloc(objInfo.texels * sizeof(GLfloat *));
    for (int i=0; i<=objInfo.texels - 1; i++) {
        result.texels[i] = malloc(2 * sizeof(GLfloat));
    }
    result.normals = malloc(objInfo.normals * sizeof(GLfloat *));
    for (int i=0; i<=objInfo.normals - 1; i++) {
        result.normals[i] = malloc(3 * sizeof(GLfloat));
    }
    result.faces = malloc(objInfo.faces * sizeof(GLint *));
    for (int i=0; i<=objInfo.faces - 1; i++) {
        result.faces[i] = malloc(9 * sizeof(GLint));
    }
    
    
    OBJInfo structIterator = {0};
    for (NSString *line in lines) {
        if ([line hasPrefix:@"v "]) {
            result.positions[structIterator.positions] = [OBJLoader floatsFromString:line];
            structIterator.positions ++;
        } else if ([line hasPrefix:@"vn"]) {
            result.normals[structIterator.normals] = [OBJLoader floatsFromString:line];
            structIterator.normals ++;
        } else if ([line hasPrefix:@"vt"]) {
            result.texels[structIterator.texels] = [OBJLoader floatsFromString:line];
            structIterator.texels ++;
        } else if ([line hasPrefix:@"f "]) {
            result.faces[structIterator.faces] = [OBJLoader facesFromString:line];
            structIterator.faces ++;
        }
    }
    return result;
}

+ (GLint *)facesFromString:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"f" withString:@""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *triangles = [string componentsSeparatedByString:@" "];
    
    GLint *result = malloc(9 * sizeof(GLint));
    unsigned int index = 0;
    for (NSString *triangle in triangles) {
        NSArray<NSString *> *components = [triangle componentsSeparatedByString:@"/"];
        for (NSString *component in components) {
            result[index] = [component intValue];
            index ++;
        }
    }
    
    return result;
}

+ (GLfloat *)floatsFromString:(NSString *)string {
    NSArray <NSString *> *floatStrings = [string componentsSeparatedByString:@" "];
    NSMutableArray *mFloatStrings = [floatStrings mutableCopy];
    [mFloatStrings removeObjectAtIndex:0];
    floatStrings = mFloatStrings;
    GLfloat *floats = malloc(floatStrings.count * sizeof(GLfloat));
    for (int i=0; i<=floatStrings.count - 1; i++) {
        floats[i] = [floatStrings[i] floatValue];
    }
    return floats;
}

@end


@implementation StrideData

- (instancetype)initWithPositionIndex:(NSUInteger)positionIndex
                           texelIndex:(NSUInteger)texelIndex
                          normalIndex:(NSUInteger)normalIndex
                            positions:(GLfloat **)positions
                               texels:(GLfloat **)texels
                              normals:(GLfloat **)normals {
    self = [super init];
    if (self) {
        self.positionIndex = positionIndex;
        self.texelIndex = texelIndex;
        self.normalIndex = normalIndex;
        self.positions = positions[positionIndex - 1];
        self.texels = texels[texelIndex - 1];
        self.normals = normals[normalIndex - 1];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if ([super isEqual:object]) {
        return YES;
    }
    if ([object isKindOfClass:[StrideData class]]) {
        return
        ((self.positionIndex == ((StrideData *)object).positionIndex) &&
         (self.texelIndex == ((StrideData *)object).texelIndex) &&
         (self.normalIndex == ((StrideData *)object).normalIndex));
    }
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%d-%d-%d", self.positionIndex, self.texelIndex, self.normalIndex];
}

@end


@implementation StrideCollection

- (NSMutableArray<StrideData *> *)array {
    if (!_array) {
        _array = [NSMutableArray new];
    }
    return _array;
}

- (NSMutableArray<NSNumber *> *)indices {
    if (!_indices) {
        _indices = [NSMutableArray new];
    }
    return _indices;
}

- (void)addObject:(StrideData *)stride {
    if ([self.array containsObject:stride]) {
        [self.indices addObject:@([self.array indexOfObject:stride] + 1)];
        return;
    }
    [self.array addObject:stride];
    [self.indices addObject:@(self.array.count)];
}

@end