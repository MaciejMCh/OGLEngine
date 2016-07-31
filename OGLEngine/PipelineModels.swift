//
//  PipelineModels.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 22.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

public struct GPUPipeline {
    let vertexShader: GPUVertexShader
    let fragmentShader: GPUFragmentShader
    let uniforms: [AnyGPUUniform]
    
    init(vertexShader: GPUVertexShader, fragmentShader: GPUFragmentShader) {
        self.vertexShader = vertexShader
        self.fragmentShader = fragmentShader
        uniforms = vertexShader.uniforms.collection + fragmentShader.uniforms.collection
    }
    
    func uniform<T>(variable: Variable<T>) -> GPUUniform<T>! {
        for uniform in uniforms {
            if uniform.name == variable.name {
                return uniform as! GPUUniform<T>
            }
        }
        return nil
    }
}
