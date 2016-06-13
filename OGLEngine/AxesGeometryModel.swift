//
//  AxesGeometryModel.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 13.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

struct AxesRotation {
    let angle: Float
    let x: Float
    let y: Float
    let z: Float
}

class AxesGeometryModel: GeometryModel {
    var staticModelMatrix: GLKMatrix4
    
    init(position: GLKVector3, axesRotation: AxesRotation) {
        self.staticModelMatrix = modelTransformatrionMatrix(position, rotation: axesRotation)
        super.init()
    }
    
    override func modelMatrix() -> GLKMatrix4 {
        return self.staticModelMatrix
    }
}