//
//  SceneEntity.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class Vector3SceneEntity : NSObject {
    var vector: GLKVector3 = GLKVector3Make(0, 0, 0)
    var uniformLocation: GLint = 0
    
    func passToShader() {
        withUnsafePointer(&self.vector, {
            glUniform3fv(self.uniformLocation, 1, UnsafePointer($0));
        })
    }
}