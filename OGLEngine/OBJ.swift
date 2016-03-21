//
//  OBJ.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation

class OBJ : NSObject {
    
    var indices : GLIntArray!
    var positions : GLFloatArray!
    var texels : GLFloatArray!
    var normals : GLFloatArray!
    var tangents : GLFloatArray!
    var bitangents : GLFloatArray!
    
    convenience init(indices: GLIntArray, positions: GLFloatArray, texels: GLFloatArray, normals: GLFloatArray) {
        self.init()
        self.indices = indices
        self.positions = positions
        self.texels = texels
        self.normals = normals
//        self.calculateTangents()
    }
    
//    func calculateTangents() {
//        for var i = 0; i < self.indices.count; i += 3 {
//            var v1: Float = Float()
//            v1.self.positions.data[self.indices.data[i + 0] + 0]
//            v1.self.positions.data[self.indices.data[i + 0] + 1]
//            v1.self.positions.data[self.indices.data[i + 0] + 2]
//            var v2: Float = Float()
//            v2.self.positions.data[self.indices.data[i + 1] + 0]
//            v2.self.positions.data[self.indices.data[i + 1] + 1]
//            v2.self.positions.data[self.indices.data[i + 1] + 2]
//            var v3: Float = Float()
//            v3.self.positions.data[self.indices.data[i + 2] + 0]
//            v3.self.positions.data[self.indices.data[i + 2] + 1]
//            v3.self.positions.data[self.indices.data[i + 2] + 2]
//            var t1: Float = Float()
//            t1.self.texels.data[self.indices.data[i + 0] + 0]
//            t1.self.texels.data[self.indices.data[i + 0] + 1]
//            var t2: Float = Float()
//            t2.self.texels.data[self.indices.data[i + 1] + 0]
//            t2.self.texels.data[self.indices.data[i + 1] + 1]
//            var t3: Float = Float()
//            t3.self.texels.data[self.indices.data[i + 2] + 0]
//            t3.self.texels.data[self.indices.data[i + 2] + 1]
//            var tangents: Float = self.processTriangle(v1, p2: v2, p3: v3, t1: t1, t2: t2, t3: t3)
//        }
//    }
    
//    func processTriangle(p1: Float, p2: Float, p3: Float, t1: Float, t2: Float, t3: Float) -> Float {
//        var e1: Float = Float()
//        e1.p2[0] - p1[0]
//        e1.p2[1] - p1[1]
//        e1.p2[2] - p1[2]
//        var e2: Float = Float()
//        e2.p3[0] - p1[0]
//        e2.p3[1] - p1[1]
//        e2.p3[2] - p1[2]
//        var d1: Float = Float()
//        d1.t2[0] - t1[0]
//        d1.t2[1] - t1[1]
//        var d2: Float = Float()
//        d2.t3[0] - t1[0]
//        d2.t3[1] - t1[1]
//        var f: GLfloat = 1.0 / (d1[0] * d2[1] - d2[0] * d1[1])
//        var ta: Float = Float()
//        ta.f * (d2[1] * e1[0] - d1[1] * e2[0])
//        ta.f * (d2[1] * e1[1] - d1[1] * e2[1])
//        ta.f * (d2[1] * e1[2] - d1[1] * e2[2])
//        var bt: Float = Float()
//        bt.f * (-d2[0] * e1[0] + d1[0] * e2[0])
//        bt.f * (-d2[0] * e1[1] + d1[0] * e2[1])
//        bt.f * (-d2[0] * e1[2] + d1[0] * e2[2])
//        var length: Float = sqrt((ta[0] * ta[0]) + (ta[1] * ta[1]) + (ta[2] * ta[2]))
//        ta[0] = ta[0] / length
//        ta[1] = ta[1] / length
//        ta[2] = ta[2] / length
//        length = sqrt((bt[0] * bt[0]) + (bt[1] * bt[1]) + (bt[2] * bt[2]))
//        bt[0] = bt[0] / length
//        bt[1] = bt[1] / length
//        bt[2] = bt[2] / length
//        var result: Float = malloc(6 * sizeof())
//        result[0] = ta[0]
//        result[1] = ta[1]
//        result[2] = ta[2]
//        result[3] = bt[0]
//        result[4] = bt[1]
//        result[5] = bt[2]
//        return result
//    }
}

class GLFloatArray: NSObject {
    var data: [GLfloat] = []
    var count: UInt = 0
}
class GLIntArray: NSObject {
    var data: [UInt] = []
    var count: UInt = 0
}