//
//  Attribute.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 30.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class AnyGPUAttribute {
    private(set) var variable: AnyGPUVariable
    private(set) var location: GLuint
    private(set) var size: Int
    
    init(variable: AnyGPUVariable, location: GLuint) {
        self.variable = variable
        self.location = location
        switch variable {
        case is GPUVariable<GLSLVec2>: size = 2
        case is GPUVariable<GLSLVec3>: size = 3
        case is GPUVariable<GLSLVec4>: size = 4
        default:
            assert(false)
            size = 0
        }
    }
}

class GPUAttribute<T: GLSLType>: AnyGPUAttribute {
    var typedVariable: GPUVariable<T>
    
    init(variable: GPUVariable<T>, location: GLuint) {
        self.typedVariable = variable
        super.init(variable: variable, location: location)
    }
}

extension AnyGPUAttribute: GPURepresentable {
    var glslName: String {
        get {
            return self.variable.name!
        }
    }
}

struct GPUAttributes {
    static let position = GPUAttribute(variable: GPUVariable<GLSLVec3>(name: "aPosition"), location: 0)
    static let texel = GPUAttribute(variable: GPUVariable<GLSLVec2>(name: "aTexel"), location: 1)
    static let normal = GPUAttribute(variable: GPUVariable<GLSLVec3>(name: "aNormal"), location: 2)
    static let tangent = GPUAttribute(variable: GPUVariable<GLSLVec3>(name: "aTangent"), location: 3)
}
