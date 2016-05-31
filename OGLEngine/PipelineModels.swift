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
    let vertexShader: VertexShader
    let fragmentShader: FragmentShader
    
    func uniform<T>(variable: TypedGPUVariable<T>) -> GPUUniform<T>! {
        for uniform in vertexShader.uniforms.collection {
            if uniform.glslName == variable.glslName {
                return uniform as! GPUUniform<T>
            }
        }
        return nil
    }
}
