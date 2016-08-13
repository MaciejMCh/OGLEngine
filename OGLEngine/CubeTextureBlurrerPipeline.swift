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
        let zoom: Float = 2
        fragmentScope ✍ texel ⬅ (texel * Primitive(value: zoom))
        fragmentScope ✍ texel ⬅ (texel - Primitive(value: GLKVector2Make(1.0 / zoom, 1.0 / zoom)))
        
        
//        fragmentScope ✍ texelX ⬅ texel.>"x"
//        fragmentScope ✍ texelY ⬅ texel.>"y"
        
        let wallIndex = Variable<GLSLInt>(name: "wallIndex")
        let transformationIndex = Variable<GLSLInt>(name: "transformationIndex")
        let uIndex1 = Variable<GLSLInt>(name: "uIndex1")
        let uIndex2 = Variable<GLSLInt>(name: "uIndex2")
        let projecteeIndex = Variable<GLSLInt>(name: "projecteeIndex")
        
        fragmentScope ✍ FixedGPUInstruction(code: stringFromLines([
            "gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);",
            
            
            "int projecteeIndex = 100;",
            "if (texel.y > 1.0) {",
            "   if(texel.x < 0.0) {",
            "       if(texel.y - 1.0 > -texel.x) {",
            "           projecteeIndex = 2;",
            "       } else {",
            "           projecteeIndex = 3;",
            "       }",
            "   } else if (texel.x < 1.0) {",
            "       projecteeIndex = 2;",
            "   } else {",
            "       if (texel.y > texel.x) {",
            "           projecteeIndex = 2;",
            "       } else {",
            "           projecteeIndex = 4;",
            "       }",
            "   }",
            "} else if (texel.y > 0.0) {",
            "   if (texel.x < 0.0) {",
            "       projecteeIndex = 3;",
            "   } else {",
            "       if (texel.x > 1.0) {",
            "           projecteeIndex = 4;",
            "       } else {",
            "           projecteeIndex = 0;",
            "       }",
            "   }",
            "} else {",
            "   if (texel.x < 0.0) {",
            "       if (texel.x < texel.y) {",
            "           projecteeIndex = 3;",
            "       } else {",
            "           projecteeIndex = 1;",
            "       }",
            "   } else {",
            "       if (texel.x < 1.0) {",
            "           projecteeIndex = 1;",
            "       } else {",
            "           if (texel.x - 1.0 > -texel.y) {",
            "               projecteeIndex = 4;",
            "           } else {",
            "               projecteeIndex = 1;",
            "           }",
            "       }",
            "   }",
            "}",
            
            "if (projecteeIndex == 0) {",
            "   gl_FragColor = texture2D(uCubeTextureCurrent, texel);",
            "   return;",
            "}",
            
            // - -
            "if (projecteeIndex < 3) {",
            "   lowp float errY = -texel.y;",
            "   lowp float splasher = (texel.x - 0.5) / (texel.y - 0.5);",
            "   lowp float tX = errY * splasher;",
            "   texel = vec2(texel.x + tX, errY);",
            "   gl_FragColor = texture2D(uCubeTextureCurrent, texel);",
            "} else {",
            "   lowp float errX = -texel.x;",
            "   lowp float splasher = (texel.y - 0.5) / (texel.x - 0.5);",
            "   lowp float tY = errX * splasher;",
            "   texel = vec2(errX, texel.y + tY);",
            "   gl_FragColor = texture2D(uCubeTextureLeft, texel);",
            "}",
            
            
            "texture2D(uCubeTextureCurrent, vec2(0.0, 0.0));",
            "texture2D(uCubeTextureLeft, vec2(0.0, 0.0));"
            
            ]), usedVariables: [GPUUniforms.CubeTextures.Current, GPUUniforms.CubeTextures.Left])
//            ]), usedVariables: [wallIndex, texel, projecteeIndex])
//        
//        let texelTransformation = Variable<GLSLMat2>(name: "texelTransformation")
//        
//        
//        var iii = 0
//        let pros = [
////            (2, 2),
////            (10, 0),
////            (1, 1),     // 2
////            (10, 0),
////            (10, 0),
////            (2, 0),     // 5
////            (10, 0),
////            (10, 0),
////            (3, 0),     // 8
////            (10, 0),
////            (10, 0),
////            (4, 0),    // 11
////            (0, 0)]
//            (10, 0),
//            (1, 0),
//            (1, 0),     // 2
//            (10, 0),
//            (10, 0),
//            (10, 0),//(2, 0),     // 5
//            (10, 0),
//            (10, 0),
//            (10, 0),     // 8
//            (10, 0),
//            (10, 0),
//            (10, 0),    // 11
//            (10, 0)]
//        for pro in pros {
//            fragmentScope ✍ ConditionInstruction(bool: projecteeIndex .== Primitive(value: iii), successInstructions: [
//                wallIndex ⬅ Primitive(value: pro.0),
//                transformationIndex ⬅ Primitive(value: pro.1)
//                ])
//            iii += 1
//        }
//        // 2 5 8
//        fragmentScope ✍ ConditionInstruction(bool: projecteeIndex .== Primitive(value: 100), successInstructions: [
//            wallIndex ⬅ uIndex1,
//            transformationIndex ⬅ uIndex2
//            ])
//        
//        
//        var i = 0
//        let transforms = [
//            GLKMatrix2(m: (1, 0, 0, 1)),
//            GLKMatrix2(m: (-1, 0, 0, 1)),
//            GLKMatrix2(m: (1, 0, 0, -1)),
//            GLKMatrix2(m: (-1, 0, 0, -1)),
//            GLKMatrix2(m: (0, 1, 1, 0)),
//            GLKMatrix2(m: (0, -1, 1, 0)),
//            GLKMatrix2(m: (0, 1, -1, 0)),
//            GLKMatrix2(m: (0, -1, -1, 0))
//        ]
//        for transform in transforms {
//            fragmentScope ✍ ConditionInstruction(bool: transformationIndex .== Primitive(value: i), successInstructions: [
//                texelTransformation ⬅ Primitive(value: transform)
//                ])
//            i += 1
//        }
//        
//        fragmentScope ✍ texel ⬅ texelTransformation * texel
//        
//        
//        let texs = [GPUUniforms.CubeTextures.Current, GPUUniforms.CubeTextures.Top, GPUUniforms.CubeTextures.Left, GPUUniforms.CubeTextures.Bottom, GPUUniforms.CubeTextures.Right]
//        var ii = 0
//        for tex in texs {
//            fragmentScope ✍ ConditionInstruction(bool: wallIndex .== Primitive(value: ii), successInstructions: [
//                OpenGLDefaultVariables.glFragColor() ⬅ tex ☒ texel])
//            ii += 1
//        }
//        
//        fragmentScope ✍ ConditionInstruction(bool: wallIndex .== Primitive(value: 10), successInstructions: [
//            OpenGLDefaultVariables.glFragColor() ⬅ Primitive(value: (r: 1.0, g: 0.0, b: 0.0, a: 1.0))])
//        
//        fragmentScope ✍ ConditionInstruction(bool: wallIndex .== Primitive(value: 11), successInstructions: [
//            OpenGLDefaultVariables.glFragColor() ⬅ Primitive(value: (r: 0.0, g: 1.0, b: 0.0, a: 1.0))])
//        fragmentScope ✍ ConditionInstruction(bool: wallIndex .== Primitive(value: 12), successInstructions: [
//            OpenGLDefaultVariables.glFragColor() ⬅ Primitive(value: (r: 1.0, g: 1.0, b: 0.0, a: 1.0))])
//        fragmentScope ✍ ConditionInstruction(bool: wallIndex .== Primitive(value: 13), successInstructions: [
//            OpenGLDefaultVariables.glFragColor() ⬅ Primitive(value: (r: 0.5, g: 0.5, b: 0.0, a: 1.0))])
//        
        
        let program = SmartPipelineProgram(vertexScope: vertexScope, fragmentScope: fragmentScope)
        NSLog("\n" + GLSLParser.scope(program.pipeline.vertexShader.function.scope!))
        NSLog("\n" + GLSLParser.scope(program.pipeline.fragmentShader.function.scope!))
        return program
    }
}