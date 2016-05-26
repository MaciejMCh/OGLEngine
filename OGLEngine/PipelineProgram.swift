//
//  PipelineProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 23.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

protocol PipelineProgram: GPUProgram {
    var pipeline: GPUPipeline {get}
}

extension PipelineProgram {
    var shaderSource: GLSLShaderCodeSource {
        get {
            return GLSLParsedCodeSource(pipeline: self.pipeline)
        }
    }
}

class SamplePipelineProgram: PipelineProgram {
    var pipeline: GPUPipeline
    var interface: GPUInterface = DefaultInterfaces.mediumShotInterface()
    var implementation: GPUImplementation = GPUImplementation(instances: [])
    var glName: GLuint = 0
    
    init() {
        self.pipeline = DefaultPipelines.MediumShot(self.interface.attributes, uniforms: self.interface.uniforms, interpolation: MediumShotInterpolation())
    }
    
    func render(renderables: [RenderableType]) {
        
    }
}