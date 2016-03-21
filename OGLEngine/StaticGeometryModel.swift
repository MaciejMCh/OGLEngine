//
//  StaticGeometryModel.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class StaticGeometryModel : NSObject, GeometryModel {
    
    var staticModelMatrix: GLKMatrix4!
    
    convenience init(position: GLKVector3) {
        self.init()
        self.staticModelMatrix = GLKMatrix4MakeTranslation(position.x, position.y, position.z)
    }
    
    convenience init(position: GLKVector3, scale: GLKVector3) {
        self.init()
        self.staticModelMatrix = GLKMatrix4MakeScale(scale.x, scale.y, scale.z)
        self.staticModelMatrix = GLKMatrix4Translate(self.staticModelMatrix, position.x, position.y, position.z)
    }
    
    func modelMatrix() -> GLKMatrix4 {
        return self.staticModelMatrix
    }
}