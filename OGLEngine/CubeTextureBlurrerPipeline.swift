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
        
        // zoom
        let zoom: Float = 2
        fragmentScope ✍ texel ⬅ (texel * Primitive(value: zoom))
        fragmentScope ✍ texel ⬅ (texel - Primitive(value: GLKVector2Make(1.0 / zoom, 1.0 / zoom)))
        
        
        let transformationIndex = Variable<GLSLInt>(name: "transformationIndex")
        let projecteeIndex = Variable<GLSLInt>(name: "projecteeIndex")
        
        fragmentScope ✍ FixedGPUInstruction(code: stringFromLines([
            "gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);",

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
            
            "if (projecteeIndex < 3) {",
            "   lowp float errY = -texel.y;",
            "   lowp float splasher = (texel.x - 0.5) / (texel.y - 0.5);",
            "   lowp float tX = errY * splasher;",
            "   texel = vec2(texel.x + tX, errY);",
            "} else {",
            "   lowp float errX = -texel.x;",
            "   lowp float splasher = (texel.y - 0.5) / (texel.x - 0.5);",
            "   lowp float tY = errX * splasher;",
            "   texel = vec2(errX, texel.y + tY);",
            "}"
            ]), usedVariables: [GPUUniforms.CubeTextures.Current, GPUUniforms.CubeTextures.Left, projecteeIndex])
        
        fragmentScope ✍ transformationIndex ⬅ (GPUUniforms.sideTexturesTransformations .| (projecteeIndex - Primitive(value: 1)))
        
        fragmentScope ✍ FixedGPUInstruction(code: stringFromLines([
            "if (transformationIndex == 1) {",
            "   texel.x = -texel.x;",
            "} else if (transformationIndex == 2) {",
            "   texel.y = -texel.y;",
            "} else if (transformationIndex == 3) {",
            "   texel = -texel;",
            "} else if (transformationIndex == 4) {",
            "   texel.x = texel.y;",
            "   texel.y = texel.x;",
            "} else if (transformationIndex == 5) {",
            "   texel.x = -texel.y;",
            "   texel.y = texel.x;",
            "} else if (transformationIndex == 6) {",
            "   texel.x = texel.y;",
            "   texel.y = -texel.x;",
            "} else if (transformationIndex == 7) {",
            "   texel.x = -texel.y;",
            "   texel.y = -texel.x;",
            "}"
            ]), usedVariables: [texel, transformationIndex])
        
        let samplers = [GPUUniforms.CubeTextures.Current,
                        GPUUniforms.CubeTextures.Bottom,
                        GPUUniforms.CubeTextures.Top,
                        GPUUniforms.CubeTextures.Left,
                        GPUUniforms.CubeTextures.Right]
        for i in 0...samplers.count - 1 {
            fragmentScope ✍ ConditionInstruction(bool: projecteeIndex .== Primitive(value: i), successInstructions: [
                OpenGLDefaultVariables.glFragColor() ⬅ samplers[i] ☒ texel
                ])
        }
        
        let program = SmartPipelineProgram(vertexScope: vertexScope, fragmentScope: fragmentScope)
        NSLog("\n" + GLSLParser.scope(program.pipeline.vertexShader.function.scope!))
        NSLog("\n" + GLSLParser.scope(program.pipeline.fragmentShader.function.scope!))
        return program
    }
}