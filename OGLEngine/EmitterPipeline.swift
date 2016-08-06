//
//  EmitterPipeline.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 06.08.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

extension DefaultPipelines {
    static func EmitterPipeline() -> SmartPipelineProgram {
        let vertexScope = GPUScope()
        vertexScope ✍ OpenGLDefaultVariables.glPosition() ⬅ GPUUniforms.modelViewProjectionMatrix * GPUAttributes.position
        
        let fragmentScope = GPUScope()
        fragmentScope ✍ OpenGLDefaultVariables.glFragColor() ⬅ Variable<GLSLColor>(name: "vColor")
        
        let program = SmartPipelineProgram(vertexScope: vertexScope, fragmentScope: fragmentScope)
        return program
    }
}