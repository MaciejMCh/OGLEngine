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
            
            "if ((texel.x > 0.0) && (texel.x < 1.0) && (texel.y > 0.0) && (texel.y < 1.0)) {",
            "   gl_FragColor = texture2D(uCubeTextureCurrent, texel);",
            "}",
            
            
            
            "if (texel.y < 0.0) {",
            "if (texel.x < texel.y) {return;}",
            "   lowp float errY = -texel.y;",
            "   lowp float tX = errY;",
//            "   tX = (1.0 - errY) * ((texel.x - 0.5) * 2.0);",
//            "   tX = tX * (texel.x / texel.y);",
            
            "   lowp float zz = (texel.x - 0.5) / (texel.y - 0.5);",
            "   gl_FragColor = vec4(zz, 0.0, 0.0, 1.0);",
            
            "   tX = tX * zz;",
            
            
            "   gl_FragColor = texture2D(uCubeTextureCurrent, vec2(texel.x + tX, errY));",
            "}",
            ""
            ]), usedVariables: [GPUUniforms.CubeTextures.Current])
//            "wallIndex = 10;",
//            "transformationIndex = uIndex1;",
        
            
//            "if ((texel.x > 0.0) && (texel.x < 1.0) && (texel.y > 0.0) && (texel.y < 1.0)) {",
//            "   wallIndex = 0;",
//            "   transformationIndex = 0;",
//            "}",
//            
//            "if (texel.y > 1.0) {",
//            "   if(texel.x < 0.0) {",
//            "       if(texel.y - 1.0 > -texel.x) {",
//            "           lowp float mist = (1.0 - texel.y);",
//            "           texel = vec2(texel.x, texel.y);",
//            "           projecteeIndex = 1;",
//            "       } else {",
//            "           lowp float mist = -texel.x * (texel.y - 0.5);",
//            "           texel = vec2(texel.x, texel.y - mist);",
//            "           projecteeIndex = 0;",
//            "       }",
//            "   } else if (texel.x < 1.0) {",
//            "       lowp float mist = (1.0 - texel.y) * (texel.x - 0.5);",
//            "       texel = vec2(texel.x + mist, texel.y);",
//            "       projecteeIndex = 2;",
//            "   } else {",
//            "       if (texel.y > texel.x) {",
//            "           projecteeIndex = 3;",
//            "       } else {",
//            "           projecteeIndex = 4;",
//            "       }",
//            "   }",
//            "} else if (texel.y > 0.0) {",
//            "   if (texel.x < 0.0) {",
//            "       lowp float mist = -texel.x * (texel.y - 0.5);",
//            "       texel = vec2(texel.x, texel.y - mist);",
//            "       projecteeIndex = 5;",
//            "   } else {",
//            "       if (texel.x > 1.0) {",
//            "           projecteeIndex = 11;",
//            "       } else {",
//            "           projecteeIndex = 12;",
//            "       }",
//            "   }",
//            "} else {",
//            "   if (texel.x < 0.0) {",
//            "       if (texel.x < texel.y) {",
//            "           projecteeIndex = 6;",
//            "       } else {",
//            "           projecteeIndex = 7;",
//            "       }",
//            "   } else {",
//            "       if (texel.x < 1.0) {",
//            "           projecteeIndex = 8;",
//            "       } else {",
//            "           if (texel.x - 1.0 > -texel.y) {",
//            "               projecteeIndex = 10;",
//            "           } else {",
//            "               projecteeIndex = 9;",
//            "           }",
//            "       }",
//            "   }",
//            "}"
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