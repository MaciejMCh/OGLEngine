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
        let originalTexel = Variable<GLSLVec2>(name: "originalTexel")
        let texelX = Variable<GLSLFloat>(name: "texelX")
        let texelY = Variable<GLSLFloat>(name: "texelY")
        
        
        
        
        
        fragmentScope ✍ texel ⬅ (vTexel + Primitive(value: GLKVector2Make(-0.2, -0.3)))
        fragmentScope ✍ originalTexel ⬅ texel
        
//        fragmentScope ✍ texelX ⬅ texel.>"x"
//        fragmentScope ✍ texelY ⬅ texel.>"y"
        
        let wallIndex = Variable<GLSLInt>(name: "wallIndex")
        let transformationIndex = Variable<GLSLInt>(name: "transformationIndex")
        let uIndex = Variable<GLSLInt>(name: "uIndex")
        
        fragmentScope ✍ FixedGPUInstruction(code: stringFromLines([
            "wallIndex = 10;",
            "transformationIndex = uIndex;",
            
            "if (texel.x < 1.0) {",
            "   if (texel.x > 0.0) {",
            "       if (texel.y < 1.0) {",
            "           if (texel.y > 0.0) {",
            "               wallIndex = 0;",
            "               transformationIndex = 0;", // mid
            "           } else {",
            "               wallIndex = 3;",
            "               transformationIndex = 2;",
            "           }",
            "       } else {",
            "   }",
            "}",
            
            ]), usedVariables: [wallIndex, texel, uIndex])
        
        let texelTransformation = Variable<GLSLMat2>(name: "texelTransformation")
        
        var i = 0
        let transforms = [
            GLKMatrix2(m: (1, 0, 0, 1)),
            GLKMatrix2(m: (-1, 0, 0, 1)),
            GLKMatrix2(m: (1, 0, 0, -1)),
            GLKMatrix2(m: (-1, 0, 0, -1)),
            GLKMatrix2(m: (0, 1, 1, 0)),
            GLKMatrix2(m: (0, -1, 1, 0)),
            GLKMatrix2(m: (0, 1, -1, 0)),
            GLKMatrix2(m: (0, -1, -1, 0))
        ]
        for transform in transforms {
            fragmentScope ✍ ConditionInstruction(bool: transformationIndex .== Primitive(value: i), successInstructions: [
                texelTransformation ⬅ Primitive(value: transform)
                ])
            i += 1
        }
        
        fragmentScope ✍ texel ⬅ texelTransformation * texel
        
        
        let texs = [GPUUniforms.CubeTextures.Current, GPUUniforms.CubeTextures.Top, GPUUniforms.CubeTextures.Left, GPUUniforms.CubeTextures.Bottom, GPUUniforms.CubeTextures.Right]
        var ii = 0
        for tex in texs {
            fragmentScope ✍ ConditionInstruction(bool: wallIndex .== Primitive(value: ii), successInstructions: [
                OpenGLDefaultVariables.glFragColor() ⬅ tex ☒ texel])
            ii += 1
        }
        
        fragmentScope ✍ ConditionInstruction(bool: wallIndex .== Primitive(value: 10), successInstructions: [
            OpenGLDefaultVariables.glFragColor() ⬅ Primitive(value: (r: 1.0, g: 0.0, b: 0.0, a: 1.0))])
        
        
        
        
        
        
//        for side in CubeTextureSide.allSidesInOrder() {
//            ConditionInstruction(bool: <#T##Evaluation<GLSLBool>#>, successInstructions: <#T##[GPUInstruction]#>)
//        }
        
//        fragmentScope ✍ ConditionInstruction(bool: wallIndex .== Primitive(value: 0),
//                                               successInstructions: [
//                                                OpenGLDefaultVariables.glFragColor() ⬅ GPUUniforms.CubeTextures.Current ☒ texel
//            ])
//        
//        // +Z
//        fragmentScope ✍ ConditionInstruction(bool: wallIndex .== Primitive(value: 1),
//                             successInstructions: [
//                                OpenGLDefaultVariables.glFragColor() ⬅ GPUUniforms.CubeTextures.Top ☒ texel
//            ])
//        fragmentScope ✍ ConditionInstruction(bool: wallIndex .== Primitive(value: 3),
//                                               successInstructions: [
//                                                texel ⬅ (Primitive(value: GLKMatrix2(m: (1, 0, 0, -1))) * originalTexel),
//                                                OpenGLDefaultVariables.glFragColor() ⬅ GPUUniforms.CubeTextures.Bottom ☒ texel
//            ])
//        fragmentScope ✍ ConditionInstruction(bool: wallIndex .== Primitive(value: 4),
//                                               successInstructions: [
//                                                texel ⬅ (Primitive(value: GLKMatrix2(m: (1, 0, 0, 1))) * originalTexel),
//                                                OpenGLDefaultVariables.glFragColor() ⬅ GPUUniforms.CubeTextures.Right ☒ texel
//            ])
//        fragmentScope ✍ ConditionInstruction(bool: wallIndex .== Primitive(value: 2),
//                                               successInstructions: [
//                                                texel ⬅ (Primitive(value: GLKMatrix2(m: (1, 0, 0, 1))) * originalTexel),
//                                                OpenGLDefaultVariables.glFragColor() ⬅ GPUUniforms.CubeTextures.Left ☒ texel
//            ])
//        
//        
//        fragmentScope ✍ ConditionInstruction(bool: wallIndex .== Primitive(value: 10),
//                                               successInstructions: [
//                                                OpenGLDefaultVariables.glFragColor() ⬅ Primitive(value: (r: 1.0, g: 0.0, b: 0.0, a: 1.0))
//            ])
        
//        // +X
//        fragmentScope ✍ ConditionInstruction(bool: texelY > Primitive(value: 1.0),
//                                               successInstructions: [
//                                                texel ⬅ (Primitive(value: GLKMatrix2(m: (0, 1, -1, 0))) * originalTexel),
//                                                OpenGLDefaultVariables.glFragColor() ⬅ GPUUniforms.CubeTextures.Top ☒ texel
//            ])
//        fragmentScope ✍ ConditionInstruction(bool: texelY < Primitive(value: 0.0),
//                                               successInstructions: [
//                                                texel ⬅ (Primitive(value: GLKMatrix2(m: (0, -1, 1, 0))) * originalTexel),
//                                                OpenGLDefaultVariables.glFragColor() ⬅ GPUUniforms.CubeTextures.Bottom ☒ texel
//            ])
//        fragmentScope ✍ ConditionInstruction(bool: texelX > Primitive(value: 1.0),
//                                               successInstructions: [
//                                                texel ⬅ (Primitive(value: GLKMatrix2(m: (1, 0, 0, 1))) * originalTexel),
//                                                OpenGLDefaultVariables.glFragColor() ⬅ GPUUniforms.CubeTextures.Right ☒ texel
//            ])
//        fragmentScope ✍ ConditionInstruction(bool: texelX < Primitive(value: 0.0),
//                                               successInstructions: [
//                                                texel ⬅ (Primitive(value: GLKMatrix2(m: (1, 0, 0, 1))) * originalTexel),
//                                                OpenGLDefaultVariables.glFragColor() ⬅ GPUUniforms.CubeTextures.Left ☒ texel
//            ])
        
        
        
        
        
        
        let program = SmartPipelineProgram(vertexScope: vertexScope, fragmentScope: fragmentScope)
        NSLog("\n" + GLSLParser.scope(program.pipeline.vertexShader.function.scope!))
        NSLog("\n" + GLSLParser.scope(program.pipeline.fragmentShader.function.scope!))
        return program
    }
}