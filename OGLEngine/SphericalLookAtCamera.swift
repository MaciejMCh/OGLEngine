//
//  LookAtCamera.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 10.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class SphericalLookAtCamera: LookAtCamera {
    var azimutalAngle: Float = 0
    var polarAngle: Float = 0
    
    override var focusPosition: GLKVector3 {
        get {
            let eyePosition = self.eyePosition
            let viewVersor = versorFromAngles(azimutalAngle, polarAngle: polarAngle)
            return GLKVector3Make(
                eyePosition.x + viewVersor.x,
                eyePosition.y + viewVersor.y,
                eyePosition.z + viewVersor.z)
        }
        set {
            
        }
    }
    
    func versorFromAngles(azimuthalAngle: Float, polarAngle: Float) -> GLKVector3 {
        let x = sin(polarAngle) * cos(azimuthalAngle)
        let y = sin(polarAngle) * sin(azimuthalAngle)
        let z = cos(polarAngle)
        return GLKVector3Make(x, y, z)
    }
    
}
