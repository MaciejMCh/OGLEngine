//
//  PipelineShader.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

public protocol Shader {
    var name: String {get}
    var interpolation: Interpolation {get}
    var function: TypedGPUFunction<GLSLVoid> {get}
}

public struct FragmentShader: Shader {
    public let name: String
    let uniforms: GLSLVariableCollection<AnyGPUUniform>
    public let interpolation: Interpolation
    public let function: TypedGPUFunction<GLSLVoid>
}

public struct VertexShader: Shader {
    public let name: String
    let attributes: GLSLVariableCollection<GPUAttribute>
    let uniforms: GLSLVariableCollection<AnyGPUUniform>
    public let interpolation: Interpolation
    public let function: TypedGPUFunction<GLSLVoid>
}