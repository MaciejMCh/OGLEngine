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

- (void)testStrideDataFromOBJLoadingResult {
    OBJLoadingResult *objLoadingResult = [OBJLoader loadOBJNamed:@"cube"];
    StrideCollection *strideCollection = [OBJLoader strideDataFromOBJLoadingResult:objLoadingResult];
    
    XCTAssertEqual(strideCollection.indices.count, 36);
    XCTAssertEqual(strideCollection.array.count, 24);
    
    XCTAssertEqual([strideCollection.indices[0] unsignedIntValue], 1);
    XCTAssertEqual([strideCollection.indices[1] unsignedIntValue], 2);
    XCTAssertEqual([strideCollection.indices[2] unsignedIntValue], 3);
    
    XCTAssertEqual([strideCollection.indices[3] unsignedIntValue], 1);
    XCTAssertEqual([strideCollection.indices[4] unsignedIntValue], 3);
    XCTAssertEqual([strideCollection.indices[5] unsignedIntValue], 4);
    
    XCTAssertEqual([strideCollection.indices[6] unsignedIntValue], 5);
    XCTAssertEqual([strideCollection.indices[7] unsignedIntValue], 6);
    XCTAssertEqual([strideCollection.indices[8] unsignedIntValue], 7);
    
    XCTAssertEqual([strideCollection.indices[9] unsignedIntValue], 5);
    XCTAssertEqual([strideCollection.indices[10] unsignedIntValue], 7);
    XCTAssertEqual([strideCollection.indices[11] unsignedIntValue], 8);
    
    XCTAssertEqual([strideCollection.indices[12] unsignedIntValue], 9);
    XCTAssertEqual([strideCollection.indices[13] unsignedIntValue], 10);
    XCTAssertEqual([strideCollection.indices[14] unsignedIntValue], 11);
    
    XCTAssertEqual([strideCollection.indices[15] unsignedIntValue], 9);
    XCTAssertEqual([strideCollection.indices[16] unsignedIntValue], 11);
    XCTAssertEqual([strideCollection.indices[17] unsignedIntValue], 12);
    
    XCTAssertEqual([strideCollection.indices[18] unsignedIntValue], 13);
    XCTAssertEqual([strideCollection.indices[19] unsignedIntValue], 14);
    XCTAssertEqual([strideCollection.indices[20] unsignedIntValue], 15);
    
    XCTAssertEqual([strideCollection.indices[21] unsignedIntValue], 13);
    XCTAssertEqual([strideCollection.indices[22] unsignedIntValue], 15);
    XCTAssertEqual([strideCollection.indices[23] unsignedIntValue], 16);
    
    XCTAssertEqual([strideCollection.indices[24] unsignedIntValue], 17);
    XCTAssertEqual([strideCollection.indices[25] unsignedIntValue], 18);
    XCTAssertEqual([strideCollection.indices[26] unsignedIntValue], 19);
    
    XCTAssertEqual([strideCollection.indices[27] unsignedIntValue], 17);
    XCTAssertEqual([strideCollection.indices[28] unsignedIntValue], 19);
    XCTAssertEqual([strideCollection.indices[29] unsignedIntValue], 20);
    
    XCTAssertEqual([strideCollection.indices[30] unsignedIntValue], 21);
    XCTAssertEqual([strideCollection.indices[31] unsignedIntValue], 22);
    XCTAssertEqual([strideCollection.indices[32] unsignedIntValue], 23);
    
    XCTAssertEqual([strideCollection.indices[33] unsignedIntValue], 21);
    XCTAssertEqual([strideCollection.indices[34] unsignedIntValue], 23);
    XCTAssertEqual([strideCollection.indices[35] unsignedIntValue], 24);
    
    // Vertices
    XCTAssertEqualWithAccuracy(strideCollection.array[0].positions[0], 1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[0].positions[1], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[0].positions[2], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[0].texels[0], 0.375624, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[0].texels[1], 0.500625, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[0].normals[0], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[0].normals[1], -1, FLT_EPSILON);;
    XCTAssertEqualWithAccuracy(strideCollection.array[0].normals[2], 0, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(strideCollection.array[3].positions[0], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[3].positions[1], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[3].positions[2], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[3].texels[0], 0.375625, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[3].texels[1], 0.749375, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[3].normals[0], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[3].normals[1], -1, FLT_EPSILON);;
    XCTAssertEqualWithAccuracy(strideCollection.array[3].normals[2], 0, FLT_EPSILON);
    
    XCTAssertEqualWithAccuracy(strideCollection.array[23].positions[0], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[23].positions[1], 1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[23].positions[2], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[23].texels[0], 0.375625, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[23].texels[1], 0.998126, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[23].normals[0], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(strideCollection.array[23].normals[1], 0, FLT_EPSILON);;
    XCTAssertEqualWithAccuracy(strideCollection.array[23].normals[2], -1, FLT_EPSILON);
}

- (void)testObjFromStrideCollection {
    OBJLoadingResult *objLoadingResult = [OBJLoader loadOBJNamed:@"cube"];
    StrideCollection *strideCollection = [OBJLoader strideDataFromOBJLoadingResult:objLoadingResult];
    OBJ *obj = [OBJLoader objFromStrideCollection:strideCollection objLoadingResult:objLoadingResult];
    
    // Counts
    XCTAssertEqual(obj.indices.count, 36);
    XCTAssertEqual(obj.positions.count, 72);
    XCTAssertEqual(obj.texels.count, 48);
    XCTAssertEqual(obj.normals.count, 72);
    
    // Indices
    XCTAssertEqual(obj.indices.data[0], 0);
    XCTAssertEqual(obj.indices.data[1], 1);
    XCTAssertEqual(obj.indices.data[2], 2);
    XCTAssertEqual(obj.indices.data[3], 0);
    XCTAssertEqual(obj.indices.data[4], 2);
    XCTAssertEqual(obj.indices.data[5], 3);
    XCTAssertEqual(obj.indices.data[6], 4);
    XCTAssertEqual(obj.indices.data[7], 5);
    XCTAssertEqual(obj.indices.data[8], 6);
    XCTAssertEqual(obj.indices.data[35], 23);
    
    // Positions
    XCTAssertEqualWithAccuracy(obj.positions.data[0], 1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.positions.data[1], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.positions.data[2], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.positions.data[3], 1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.positions.data[4], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.positions.data[5], 1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.positions.data[9], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.positions.data[10], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.positions.data[11], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.positions.data[69], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.positions.data[70], 1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.positions.data[71], -1, FLT_EPSILON);
    
    // Texels
    XCTAssertEqualWithAccuracy(obj.texels.data[0], 0.375624, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.texels.data[1], 0.500625, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.texels.data[6], 0.375625, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.texels.data[7], 0.749375, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.texels.data[46], 0.375625, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.texels.data[47], 0.998126, FLT_EPSILON);
    
    // Normals
    XCTAssertEqualWithAccuracy(obj.normals.data[0], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.normals.data[1], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.normals.data[2], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.normals.data[9], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.normals.data[10], -1, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.normals.data[11], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.normals.data[69], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.normals.data[70], 0, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(obj.normals.data[71], -1, FLT_EPSILON);
}

@end
