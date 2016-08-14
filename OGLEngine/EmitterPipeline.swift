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
        let vEmissionColor = Variable<GLSLColor>(name: "vEmissionColor")
        let emissionPower = Variable<GLSLFloat>(name: "emissionPower")
        
        vertexScope ✍ ConditionInstruction(bool: (GPUAttributes.texel .> "x") > Primitive(value: 0.0), successInstructions: [
            emissionPower ⬅ Primitive(value: 1.0)
            ], failureInstructions: [
                emissionPower ⬅ Primitive(value: 0.0)
            ])
        vertexScope ✍ vEmissionColor ⬅ VecInits.fixedAlphaColor(GPUUniforms.emissionColor, alpha: emissionPower)
        vertexScope ✍ OpenGLDefaultVariables.glPosition() ⬅ GPUUniforms.modelViewProjectionMatrix * GPUAttributes.position
        
        let fragmentScope = GPUScope()
        fragmentScope ✍ OpenGLDefaultVariables.glFragColor() ⬅ vEmissionColor
        
        let program = SmartPipelineProgram(vertexScope: vertexScope, fragmentScope: fragmentScope)
        return program
    }
}