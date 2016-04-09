//
//  DirectionalLight.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class DirectionalLight: Vector3Pass {
    
    var vector3Pass: GLKVector3 {
        get {
            return self.lightDirection
        }
    }
    
    var lightDirection : GLKVector3!
    
    convenience init(lightDirection: GLKVector3) {
        self.init()
        self.lightDirection = GLKVector3Normalize(lightDirection)
    }
    
    func direction() -> GLKVector3 {
        return self.lightDirection
    }
    
    func halfVectorWithCamera(camera: Camera) -> GLKVector3 {
        let normalizedLightDirection: GLKVector3 = self.lightDirection
        let normalizedCameraPosition: GLKVector3 = GLKVector3Normalize(camera.cameraPosition())
        return GLKVector3Normalize(GLKVector3Subtract(normalizedLightDirection, normalizedCameraPosition))
    }
}