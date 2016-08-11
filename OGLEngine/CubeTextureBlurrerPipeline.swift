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
        let texelX = Variable<GLSLFloat>(name: "texelX")
        let texelY = Variable<GLSLFloat>(name: "texelY")
        
        
        
        
        
        fragmentScope ✍ texel ⬅ (vTexel + Primitive(value: GLKVector2Make(0, 0.5)))
        
        fragmentScope ✍ texelX ⬅ texel.>"x"
        fragmentScope ✍ texelY ⬅ texel.>"y"
        
        
        
//        fragmentScope ✍ ConditionInstruction(bool: texelY > Primitive(value: 1.0),
//                             successInstructions: [
//                                texel ⬅ (Primitive(value: GLKVector2Make(0.0, 1.0)) - texel),
////                                texel ⬅ (Primitive(value: GLKMatrix2(m: (1, 0, 0, 1))) * texel), // TP TP
//                                texel ⬅ (Primitive(value: GLKMatrix2(m: (0, -1, -1, 0))) * texel),
//                                OpenGLDefaultVariables.glFragColor() ⬅ GPUUniforms.CubeTextures.Top ☒ texel
//            ],
//                             failureInstructions: [
//                                OpenGLDefaultVariables.glFragColor() ⬅ GPUUniforms.CubeTextures.Current ☒ texel
//            ])
        
        
        
        
        fragmentScope ✍ OpenGLDefaultVariables.glFragColor() ⬅ GPUUniforms.CubeTextures.Current ☒ texel
//        fragmentScope ✍ OpenGLDefaultVariables.glFragColor() ⬅ Primitive(value: (r: 0.0, 1.0, 0.0, 1.0))
        
        let program = SmartPipelineProgram(vertexScope: vertexScope, fragmentScope: fragmentScope)
        NSLog("\n" + GLSLParser.scope(program.pipeline.vertexShader.function.scope!))
        NSLog("\n" + GLSLParser.scope(program.pipeline.fragmentShader.function.scope!))
        return program
    }
}