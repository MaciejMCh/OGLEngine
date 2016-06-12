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
    
    init(variable: AnyGPUVariable, location: GLuint) {
        self.variable = variable
        self.location = location
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
    static let position = GPUAttribute(variable: GPUVariable<GLSLVec4>(name: "aPosition"), location: 0)
    static let texel = GPUAttribute(variable: GPUVariable<GLSLVec2>(name: "aTexel"), location: 1)
    static let normal = GPUAttribute(variable: GPUVariable<GLSLVec3>(name: "aNormal"), location: 2)
    static let tangent = GPUAttribute(variable: GPUVariable<GLSLVec3>(name: "aTangent"), location: 3)
    static let tbnCol1 = GPUAttribute(variable: GPUVariable<GLSLVec3>(name: "aTBNCol1"), location: 4)
    static let tbnCol2 = GPUAttribute(variable: GPUVariable<GLSLVec3>(name: "aTBNCol2"), location: 5)
    static let tbnCol3 = GPUAttribute(variable: GPUVariable<GLSLVec3>(name: "aTBNCol3"), location: 6)
}
