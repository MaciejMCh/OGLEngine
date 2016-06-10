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
    private var azimutalAngle: Float = 0
    private var polarAngle: Float = 0
    private var position: GLKVector3 = GLKVector3Make(0, -1, 0)
    
    func cameraPosition() -> GLKVector3 {
        return self.position
    }
    
    func viewProjectionMatrix() -> GLKMatrix4 {
        return GLKMatrix4MakeLookAt(position.x, position.y, position.z, 0, 0, 0, 0, 0, 1)
    }
    
}