//
//  StaticGeometryModel.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation

class StaticGeometryModel {
    
    var staticModelMatrix: GLKMatrix4!
    
    convenience init(modelMatrix: GLKMatrix4) {
        self.init()
        self.staticModelMatrix = modelMatrix
    }
    
    func modelMatrix() -> GLKMatrix4 {
        return self.staticModelMatrix
    }
}