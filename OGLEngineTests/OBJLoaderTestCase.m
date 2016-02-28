//
//  OBJLoaderTestCase.m
//  OGLEngine
//
//  Created by Maciej Chmielewski on 28.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OBJLoader.h"

@interface OBJLoaderTestCase : XCTestCase

@end

@implementation OBJLoaderTestCase

//    XCTAssertEqualWithAccuracy(obj.objInfo.vertices, 1, FLT_EPSILON);

- (void)testOBJLoadingResult {
    OBJLoadingResult *objLoadingResult = [OBJLoader loadOBJNamed:@"cube"];
    
    XCTAssertEqual(objLoadingResult.objInfo.positions, 8);
    XCTAssertEqual(objLoadingResult.objInfo.texels, 14);
    XCTAssertEqual(objLoadingResult.objInfo.normals, 6);
    XCTAssertEqual(objLoadingResult.objInfo.faces, 12);
    
    // Positions
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[0][0], 1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[0][1], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[0][2], -1, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[1][0], 1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[1][1], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[1][2], 1, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[2][0], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[2][1], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[2][2], 1, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[3][0], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[3][1], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[3][2], -1, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[4][0], 1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[4][1], 1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[4][2], -0.999999, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[5][0], 0.999999, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[5][1], 1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[5][2], 1.000001, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[6][0], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[6][1], 1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[6][2], 1, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[7][0], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[7][1], 1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.positions[7][2], -1, FLT_EPSILON);
    
    // Texels
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[0][0], 0.375624, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[0][1], 0.500625, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[1][0], 0.624375, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[1][1], 0.500624, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[2][0], 0.624375, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[2][1], 0.749375, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[3][0], 0.375625, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[3][1], 0.749375, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[4][0], 0.375625, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[4][1], 0.251875, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[5][0], 0.375624, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[5][1], 0.003126, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[6][0], 0.624373, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[6][1], 0.003126, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[7][0], 0.624374, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[7][1], 0.251874, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[8][0], 0.873126, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[8][1], 0.749375, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[9][0], 0.873126, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[9][1], 0.998126, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[10][0], 0.624375, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[10][1], 0.998126, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[11][0], 0.375625, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[11][1], 0.998126, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[12][0], 0.126874, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[12][1], 0.998126, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[13][0], 0.126874, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.texels[13][1], 0.749375, FLT_EPSILON);
    
    // Normals
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[0][0], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[0][1], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[0][2], 0, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[1][0], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[1][1], 1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[1][2], 0, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[2][0], 1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[2][1], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[2][2], 0, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[3][0], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[3][1], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[3][2], 1, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[4][0], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[4][1], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[4][2], 0, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[5][0], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[5][1], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(objLoadingResult.normals[5][2], -1, FLT_EPSILON);
}

@end
