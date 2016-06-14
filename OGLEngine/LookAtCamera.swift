//
//  LookAtCamera.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 10.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class LookAtCamera: Camera {
    var eyePosition: GLKVector3 = GLKVector3Make(0, -1, 0)
    var focusPosition: GLKVector3 = GLKVector3Make(0, 0, 0)
    private var staticProjectionMatrix: GLKMatrix4
    
    init() {
        let aspect: Float = fabs(Float(UIScreen.mainScreen().bounds.size.width) / Float(UIScreen.mainScreen().bounds.size.height))
        self.staticProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 100.0)
    }
    
    func cameraPosition() -> GLKVector3 {
        let position = self.eyePosition
        return GLKVector3Make(position.x, position.y, position.z)
    }
    
    func viewProjectionMatrix() -> GLKMatrix4 {
        let position = self.eyePosition
        let focusPosition = self.focusPosition
        let viewMatrix = GLKMatrix4MakeLookAt(
            position.x,
            position.y,
            position.z,
            focusPosition.x,
            focusPosition.y,
            focusPosition.z,
            0, 0, 1)
        return viewMatrix * self.staticProjectionMatrix
    }
    
}
