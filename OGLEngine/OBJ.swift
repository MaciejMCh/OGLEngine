//
//  OBJ.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class OBJ : NSObject {
    
    var indices : GLIntArray!
    var positions : GLFloatArray!
    var texels : GLFloatArray!
    var normals : GLFloatArray!
    var tbnMatrices1 : GLFloatArray!
    var tbnMatrices2 : GLFloatArray!
    var tbnMatrices3 : GLFloatArray!
    
    convenience init(indices: GLIntArray, positions: GLFloatArray, texels: GLFloatArray, normals: GLFloatArray) {
        self.init()
        self.indices = indices
        self.positions = positions
        self.texels = texels
        self.normals = normals
    }
}

class GLFloatArray: NSObject {
    var data: [GLfloat] = []
    var count: UInt = 0
}
class GLIntArray: NSObject {
    var data: [UInt] = []
    var count: UInt = 0
}