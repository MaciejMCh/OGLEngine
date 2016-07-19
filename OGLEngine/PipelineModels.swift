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
    
    func uniform<T>(variable: Variable<T>) -> GPUUniform<T>! {
        for uniform in vertexShader.uniforms.collection {
            if uniform.name == variable.name {
                return uniform as! GPUUniform<T>
            }
        }
        return nil
    }
}
