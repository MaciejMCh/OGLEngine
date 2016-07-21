//
//  PipelineShader.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

public protocol GPUShader {
    var name: String {get}
    var interpolation: GPUInterpolation {get}
    var function: MainGPUFunction {get}
}

public struct GPUFragmentShader: GPUShader {
    public let name: String
    let uniforms: UniformsCollection
    public let interpolation: GPUInterpolation
    public let function: MainGPUFunction
}

public struct GPUVertexShader: GPUShader {
    public let name: String
    let attributes: GPUAttributesCollection
    let uniforms: UniformsCollection
    public let interpolation: GPUInterpolation
    public let function: MainGPUFunction
}