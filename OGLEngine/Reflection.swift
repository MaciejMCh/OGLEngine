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
        let position = camera.position
        let orientation = camera.orientation
        return BasicCamera(position: GLKVector3Make(position.x, position.y, -position.z), orientation: GLKVector3Make(orientation.x, -orientation.y, orientation.z))
    }
}