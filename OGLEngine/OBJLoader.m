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
@property (nonatomic, assign, readwrite) float *positions;
@property (nonatomic, assign, readwrite) float *texels;
@property (nonatomic, assign, readwrite) float *normals;
@property (nonatomic, assign, readwrite) unsigned int *faces;

@end

@implementation OBJLoadingResult

@end


@implementation OBJLoader

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
            objInfo.positions += 3;
        } else if ([line hasPrefix:@"vn"]) {
            objInfo.normals += 3;
        } else if ([line hasPrefix:@"vt"]) {
            objInfo.texels += 2;
        } else if ([line hasPrefix:@"f "]) {
            objInfo.faces +=9;
        }
    }
    objInfo.vertices = objInfo.faces * 3;
    result.objInfo = objInfo;
    
    // init arrays
    float positions[objInfo.positions];
    float texels[objInfo.texels];
    float normals[objInfo.normals];
    unsigned int faces[objInfo.faces];
    
    
    OBJInfo structIterator = {0};
    for (NSString *line in lines) {
        if ([line hasPrefix:@"v "]) {
            float *floats = [OBJLoader floatsFromString:line];
            for (int i=0; i<3; i++) {
                positions[structIterator.positions ++] = floats[i];
            }
        } else if ([line hasPrefix:@"vn"]) {
            float *floats = [OBJLoader floatsFromString:line];
            for (int i=0; i<3; i++) {
                normals[structIterator.normals ++] = floats[i];
            }
        } else if ([line hasPrefix:@"vt"]) {
            float *floats = [OBJLoader floatsFromString:line];
            for (int i=0; i<2; i++) {
                texels[structIterator.texels ++] = floats[i];
            }
        } else if ([line hasPrefix:@"f "]) {
            GLint *ints = [OBJLoader facesFromString:line];
            for (int i=0; i<9; i++) {
                faces[structIterator.faces ++] = ints[i];
            }
        }
    }
    
    result.positions = positions;
    result.texels = texels;
    result.normals = normals;
    result.faces = faces;
    
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

+ (float *)floatsFromString:(NSString *)string {
    NSArray <NSString *> *floatStrings = [string componentsSeparatedByString:@" "];
    NSMutableArray *mFloatStrings = [floatStrings mutableCopy];
    [mFloatStrings removeObjectAtIndex:0];
    floatStrings = mFloatStrings;
    float *floats = malloc(floatStrings.count * sizeof(float));
    for (int i=0; i<=floatStrings.count - 1; i++) {
        floats[i] = [floatStrings[i] floatValue];
    }
    return floats;
}

@end
