//
//  VisibleReflectionContext.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 11.04.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

struct VisibleReflectionContext {
    let model: GeometryModel
    let camera: Camera
    let light: DirectionalLight
    
    func halfVector() -> GLKVector3 {
        let lightVersor = GLKVector3Normalize(GLKVector3MultiplyScalar(light.direction(), -1))
        let cameraPosition = camera.cameraPosition()
        let viewVersor = GLKVector3Normalize(GLKVector3Subtract(cameraPosition, model.position))
        let halfVersor = GLKVector3Normalize(GLKVector3Add(lightVersor, viewVersor))
        
        return halfVersor
    }
}

extension VisibleReflectionContext: Vector3Pass {
    var vector3Pass: GLKVector3 {
        get {
            return self.halfVector()
        }
    }
}