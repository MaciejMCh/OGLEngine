//
//  ReflectedCamera.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 15.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

extension Camera {
    func viewMatrix() -> GLKMatrix4 {
        assert(false)
        return GLKMatrix4Identity;
    }
    func projectionMatrix() -> GLKMatrix4 {
        assert(false)
        return GLKMatrix4Identity;
    }
}

struct ReflectedCamera: Camera {
    let camera: LookAtCamera
    let reflectionPlane: ReflectionPlane
    
    func cameraPosition() -> GLKVector3 {
        return camera.cameraPosition()
    }
    
    func viewProjectionMatrix() -> GLKMatrix4 {
//        return reflectionPlane.reflectedCamera(camera as! LookAtCamera).viewProjectionMatrix()
//        debugPrint("\(reflectionPlane.geometryModel.modelMatrix().m)")
//        return reflectionPlane.reflectedCamera(camera as! LookAtCamera).viewProjectionMatrix() * reflectionPlane.geometryModel.modelMatrix()
        
        let invertedCamera = reflectionPlane.reflectedCamera(camera)
        
        return invertedCamera.viewProjectionMatrix()
        
        let projectionMatrix = invertedCamera.projectionMatrix()
        let viewMatrix = invertedCamera.viewMatrix()
        let transformation = reflectionPlane.geometryModel.modelMatrix()
        
        let modifiedViewMatrix = viewMatrix * transformation
        
//        debugPrint("\(viewMatrix.m)")
        
        return modifiedViewMatrix * projectionMatrix
        
    }
}