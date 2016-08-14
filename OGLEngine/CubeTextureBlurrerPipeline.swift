//
//  CubeTextureBlurrerPipeline.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 09.08.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

extension DefaultPipelines {
    static func CubeTextureBlurrer() -> SmartPipelineProgram {
        let vTexel = Variable<GLSLVec2>(name: "vTexel")
        
        let vertexScope = GPUScope()
        vertexScope ✍ vTexel ⬅ GPUAttributes.texel
        vertexScope ✍ OpenGLDefaultVariables.glPosition() ⬅ GPUAttributes.position
        
        let fragmentScope = GPUScope()
        let texel = Variable<GLSLVec2>(name: "texel")
        
        fragmentScope ✍ texel ⬅ vTexel
        fragmentScope ⥥ GPUUniforms.CubeTextures.Current
        fragmentScope ⥥ GPUUniforms.CubeTextures.Top
        fragmentScope ⥥ GPUUniforms.CubeTextures.Left
        fragmentScope ⥥ GPUUniforms.CubeTextures.Bottom
        fragmentScope ⥥ GPUUniforms.CubeTextures.Right
        fragmentScope ⥥ GPUUniforms.sideTexturesTransformations
        
        let cubeMapColorWithTexel = DefaultGPUFunction.cubeMapColorWithTexel()
        fragmentScope ↳ cubeMapColorWithTexel
        fragmentScope ✍ OpenGLDefaultVariables.glFragColor() ⬅ (cubeMapColorWithTexel .< [texel])
        
        let program = SmartPipelineProgram(vertexScope: vertexScope, fragmentScope: fragmentScope)
        NSLog("\n" + GLSLParser.scope(program.pipeline.vertexShader.function.scope!))
        NSLog("\n" + GLSLParser.scope(program.pipeline.fragmentShader.function.scope!))
        return program
    }
}