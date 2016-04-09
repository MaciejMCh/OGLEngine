//
//  GPUPassFunctions.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 10.04.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

struct GPUPassFunctions {
    static func vec3Pass(var vec3: GLKVector3, location: GLint) {
        withUnsafePointer(&vec3, {
            glUniform3fv(location, 1, UnsafePointer($0))
        })
    }
}