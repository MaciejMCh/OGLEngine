//
//  OBJ.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

struct OBJ {
    
    let indices : GLIntArray
    
    let positions : GLFloatArray?
    let texels : GLFloatArray?
    let normals : GLFloatArray?
    let tbnMatrices1 : GLFloatArray?
    let tbnMatrices2 : GLFloatArray?
    let tbnMatrices3 : GLFloatArray?
    
    func dataOfType(vboType: VBOType) -> GLFloatArray {
        switch vboType {
        case .Position: return self.positions!
        case .Texel: return self.texels!
        case .Normal: return self.normals!
        case .TangentMatrixCol1: return self.tbnMatrices1!
        case .TangentMatrixCol2: return self.tbnMatrices2!
        case .TangentMatrixCol3: return self.tbnMatrices3!
        }
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