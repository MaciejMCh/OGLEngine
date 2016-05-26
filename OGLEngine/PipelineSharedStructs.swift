//
//  PipelineSharedStructs.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 22.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

protocol GPUSharedStruct {
    
}

struct PhongFactors: GPUSharedStruct {
    let ndl: TypedGPUVariable<GLSLFloat>
    let ndh: TypedGPUVariable<GLSLFloat>
}

extension GPUSharedStruct {
    func GPUVariable<T>() -> TypedGPUVariable<T> {
        return TypedGPUVariable<T>(value: self as! T)
    }
}