//
//  StaticGeometryModel.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class StaticGeometryModel: GeometryModel {
    
    var staticModelMatrix: GLKMatrix4?
    
    override func modelMatrix() -> GLKMatrix4 {
        if (self.staticModelMatrix == nil) {
            self.staticModelMatrix = super.modelMatrix()
        }
        return self.staticModelMatrix!
    }
}