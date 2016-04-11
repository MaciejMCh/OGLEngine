//
//  GeometryModel.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class GeometryModel {
    
    var position: GLKVector3
    var orientation: GLKVector3
    
    init() {
        self.position = GLKVector3Make(0, 0, 0)
        self.orientation = GLKVector3Make(0, 0, 0)
    }
    
    init(position: GLKVector3) {
        self.position = position
        self.orientation = GLKVector3Make(0, 0, 0)
    }
    
    init(orientation: GLKVector3) {
        self.position = GLKVector3Make(0, 0, 0)
        self.orientation = orientation
    }
    
    init(position: GLKVector3, orientation: GLKVector3) {
        self.position = position
        self.orientation = orientation
    }
    
    func modelMatrix() -> GLKMatrix4 {
        return transformatrionMatrix(self.position, orientation: self.orientation)
    }
    
}
