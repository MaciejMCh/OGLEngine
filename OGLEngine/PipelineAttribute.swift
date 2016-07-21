//
//  Attribute.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 30.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

protocol AnyGPUAttribute: AnyVariable {
    var location: GLuint {get set}
    var size: Int {get}
}

class GPUAttribute<T: GLSLType>: Variable<T>, AnyGPUAttribute {
    var location: GLuint
    var size: Int
    
    init(name: String, location: GLuint) {
        self.location = location
        size = 0
        super.init(name: name)
        switch self {
        case is Variable<GLSLVec2>: size = 2
        case is Variable<GLSLVec3>: size = 3
        case is Variable<GLSLVec4>: size = 4
        default:
            assert(false)
            size = 0
        }
    }
    
}

struct GPUAttributes {
    static let position = GPUAttribute<GLSLVec3>(name: "aPosition", location: 0)
    static let texel = GPUAttribute<GLSLVec2>(name: "aTexel", location: 1)
    static let normal = GPUAttribute<GLSLVec3>(name: "aNormal", location: 2)
    static let tangent = GPUAttribute<GLSLVec3>(name: "aTangent", location: 3)
}

extension Array where Element: AnyGPUAttribute {
    func get(variable: AnyVariable) -> AnyGPUAttribute! {
        return nil
    }
//    func get<T>(variable: T) -> T! {
//        return nil
//    }
}
