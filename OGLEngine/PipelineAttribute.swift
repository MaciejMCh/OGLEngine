//
//  Attribute.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 30.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

struct GPUAttribute {
    let variable: AnyGPUVariable
    let location: GLuint
}

extension GPUAttribute: GPURepresentable {
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
    static let tbn = GPUAttribute(variable: GPUVariable<GLSLMat3>(name: "aTBN"), location: 3)
    
    static func get(variable: AnyGPUVariable) -> GPUAttribute! {
        switch variable.name! {
        case "aPosition": return position
        case "aTexel": return texel
        case "aNormal": return normal
        case "aTBN": return tbn
        default: return nil
        }
    }
}
