//
//  LightingIdeaImplementation.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 18.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

extension DefaultPipelines {
    static func LightingIdeaImplementation() {
        let vertexScope = GPUScope()
        
        vertexScope ✍ Variable<GLSLVec2>(name: "texel") ⬅ GPUAttributes.texel.typedVariable
        vertexScope ✍ Variable<GLSLVec2>(name: "texel") ⬅ GPUAttributes.texel.typedVariable * Primitive<GLSLFloat>(value: 10)
        vertexScope ✍ OpenGLDefaultVariables.glPosition() ⬅ GPUUniforms.modelViewProjectionMatrix * GPUAttributes.position.typedVariable
        
        GPUPipeline.smartPipeline(vertexScope: vertexScope, fragmentScope: vertexScope)
    }
}