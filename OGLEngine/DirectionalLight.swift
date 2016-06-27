//
//  DirectionalLight.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class DirectionalLight {
    
    var lightDirection : GLKVector3
    
    init(lightDirection: GLKVector3 = GLKVector3Make(0, 1, -1)) {
        self.lightDirection = GLKVector3Normalize(lightDirection)
    }
    
    func direction() -> GLKVector3 {
        return self.lightDirection
    }
    
    func lightVersor() -> GLKVector3 {
        let lightDirection = self.direction()
        return GLKVector3Make(-lightDirection.x, -lightDirection.y, -lightDirection.z)
    }
    
    func halfVectorWithCamera(camera: Camera) -> GLKVector3 {
        let normalizedLightDirection: GLKVector3 = self.lightDirection
        let normalizedCameraPosition: GLKVector3 = GLKVector3Normalize(camera.cameraPosition())
        return GLKVector3Normalize(GLKVector3Subtract(normalizedLightDirection, normalizedCameraPosition))
    }
}