//
//  Reflection.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 18.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

struct ReflectionPlane {
    let A: Float = 0
    let B: Float = 0
    let C: Float = 1
    let D: Float = 0
    
    func reflectedCamera(camera: BasicCamera) -> BasicCamera {
        var position = camera.position
        position = GLKVector3Make(position.x, position.y, -position.z)
        
        var orientation = camera.orientation
        let moduloAngle = fmod(orientation.x, Float(M_PI * 2))
        let angleDiff = moduloAngle - Float(M_PI_2 * 3)
        let fixedAngle = moduloAngle - (angleDiff * 2)
        orientation = GLKVector3Make(fixedAngle, orientation.y, orientation.z)
        
        return BasicCamera(position: position, orientation: orientation)
    }
}