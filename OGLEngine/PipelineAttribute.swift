//
//  Attribute.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 30.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class AnyGPUAttribute: AnyVariable {
    private(set) var variable: AnyVariable
    private(set) var location: GLuint
    private(set) var size: Int
    
    var name: String {
        return variable.name
    }
    
    init(variable: AnyVariable, location: GLuint) {
        self.variable = variable
        self.location = location
        switch variable {
        case is Variable<GLSLVec2>: size = 2
        case is Variable<GLSLVec3>: size = 3
        case is Variable<GLSLVec4>: size = 4
        default:
            assert(false)
            size = 0
        }
    }
}

class GPUAttribute<T: GLSLType>: AnyGPUAttribute {
    var typedVariable: Variable<T>
    
    init(variable: Variable<T>, location: GLuint) {
        self.typedVariable = variable
        super.init(variable: variable, location: location)
    }
}

struct GPUAttributes {
    static let position = GPUAttribute(variable: Variable<GLSLVec3>(name: "aPosition"), location: 0)
    static let texel = GPUAttribute(variable: Variable<GLSLVec2>(name: "aTexel"), location: 1)
    static let normal = GPUAttribute(variable: Variable<GLSLVec3>(name: "aNormal"), location: 2)
    static let tangent = GPUAttribute(variable: Variable<GLSLVec3>(name: "aTangent"), location: 3)
}
