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
    internal var azimutalAngle: Float = 0
    internal var polarAngle: Float = 0
    internal var position: GLKVector3 = GLKVector3Make(0, -1, 0)
    private var staticProjectionMatrix: GLKMatrix4
    
    init() {
        let aspect: Float = fabs(Float(UIScreen.mainScreen().bounds.size.width) / Float(UIScreen.mainScreen().bounds.size.height))
        self.staticProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 100.0)
    }
    
    func cameraPosition() -> GLKVector3 {
        let position = self.position
        return GLKVector3Make(position.x, position.y, position.z)
    }
    
    func viewProjectionMatrix() -> GLKMatrix4 {
        let position = self.cameraPosition()
        let lookAtVersor = versorFromAngles(azimutalAngle, polarAngle: polarAngle)
        let viewMatrix = GLKMatrix4MakeLookAt(
            position.x,
            position.y,
            position.z,
            
            position.x + lookAtVersor.x,
            position.y + lookAtVersor.y,
            position.z + lookAtVersor.z,
            
            0, 0, 1)
        return viewMatrix * self.staticProjectionMatrix
    }
    
}

func versorFromAngles(azimuthalAngle: Float, polarAngle: Float) -> GLKVector3 {
    let x = sin(polarAngle) * cos(azimuthalAngle)
    let y = sin(polarAngle) * sin(azimuthalAngle)
    let z = cos(polarAngle)
    return GLKVector3Make(x, y, z)
}