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
        
        let blurRadius: Float = 0.008
        let samplesRadius = 1
        let samplesInLine = 1 + samplesRadius * 2
        let samplesCount = Int(pow(Float(samplesInLine), Float(2)))
        let sampleDistance = blurRadius * 2.0 / Float(samplesInLine - 1)
        
        fragmentScope ✍ FixedGPUInstruction(code: stringFromLines([
            "lowp float z = 0.0;",
            "lowp vec4 blurredColor = vec4(0.0, 0.0, 0.0, 0.0);",
            "for (int ix = -\(samplesRadius); ix <= \(samplesRadius); ix++) {",
            "   for (int iy = -\(samplesRadius); iy <= \(samplesRadius); iy++) {",
            "       lowp vec2 iTexel = vec2(texel.x + float(ix) * \(sampleDistance), texel.y + float(iy) * \(sampleDistance));",
            "       lowp vec4 iColor = cubeMapColorWithTexel(iTexel);",
            "       blurredColor = blurredColor + iColor;",
            "   }",
            "}",
            "gl_FragColor = blurredColor / \(samplesCount).0;"
            ]), usedVariables: [])
        
//        fragmentScope ✍ OpenGLDefaultVariables.glFragColor() ⬅ (cubeMapColorWithTexel .< [texel])
        
        let program = SmartPipelineProgram(vertexScope: vertexScope, fragmentScope: fragmentScope)
//        NSLog("\n" + GLSLParser.scope(program.pipeline.vertexShader.function.scope!))
//        NSLog("\n" + GLSLParser.scope(program.pipeline.fragmentShader.function.scope!))
        return program
    }
}