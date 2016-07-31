//
//  LightingIdeaImplementation.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 18.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

extension DefaultPipelines {
    static func LightingIdeaImplementation() -> SmartPipelineProgram {
        let vertexScope = GPUScope()
        let worldSpacePosition = Variable<GLSLVec4>(name: "worldSpacePosition")
        let vLightVersor = Variable<GLSLVec3>(name: "vLightVersor")
        let positionVector = Variable<GLSLVec3>(name: "positionVector")
        let viewVersor = Variable<GLSLVec3>(name: "viewVersor")
        let vHalfVersor = Variable<GLSLVec3>(name: "vHalfVersor")
        
        let halfVersorScope = DefaultScopes.PhongHalfVersor(
            vLightVersor,
            modelPosition: positionVector,
            eyePosition: GPUUniforms.eyePosition,
            viewVersor: viewVersor,
            halfVersor: vHalfVersor)
        vertexScope ✍ Variable<GLSLVec2>(name: "vTexel") ⬅ GPUAttributes.texel
        vertexScope ✍ worldSpacePosition ⬅ GPUUniforms.modelMatrix * GPUAttributes.position
        vertexScope ✍ positionVector ⬅ VecInits.vec3(worldSpacePosition)
        vertexScope ⎘ DefaultScopes.FragmentTBNMatrixScope()
        vertexScope ⎘ halfVersorScope
        vertexScope ✍ OpenGLDefaultVariables.glPosition() ⬅ GPUUniforms.viewProjectionMatrix * worldSpacePosition
        
        let fragmentScope = GPUScope()
        let fixedNormal = Variable<GLSLVec3>(name: "fixedNormal")
        let lightVersor = Variable<GLSLVec3>(name: "lightVersor")
        let halfVersor = Variable<GLSLVec3>(name: "halfVersor")
        let lightColor = Variable<GLSLColor>(name: "lightColor")
        let fullDiffuseColor = Variable<GLSLColor>(name: "fullDiffuseColor")
        
        let specularSample = Variable<GLSLFloat>(name: "specularSample")
        let vSpecularPower = Variable<GLSLFloat>(name: "vSpecularPower")
        let vSpecularWidth = Variable<GLSLFloat>(name: "vSpecularWidth")
        let vAmbiencePower = Variable<GLSLFloat>(name: "vAmbiencePower")
        let uColorMap = Variable<GLSLTexture>(name: "uColorMap")
        let vTexel = Variable<GLSLVec2>(name: "vTexel")
        let vLightColor = Variable<GLSLColor>(name: "vLightColor")
        
        let uSpecularMap = Variable<GLSLTexture>(name: "uSpecularMap")
        let normalMapSample = Variable<GLSLColor>(name: "normalMapSample")
        let uNormalMap = Variable<GLSLTexture>(name: "uNormalMap")
        let vTBNMatrix = Variable<GLSLMat3>(name: "vTBNMatrix")
        
        // Vectors
        fragmentScope ✍ lightVersor ⬅ ^vLightVersor
        fragmentScope ✍ halfVersor ⬅ ^vHalfVersor
        fragmentScope ✍ lightColor ⬅ vLightColor
        fragmentScope ✍ specularSample ⬅ uSpecularMap ☒ vTexel
        fragmentScope ✍ normalMapSample ⬅ uNormalMap ☒ vTexel
        fragmentScope ✍ fixedNormal ⬅ ⤺normalMapSample
        fragmentScope ✍ fixedNormal ⬅ ^fixedNormal
        fragmentScope ✍ fixedNormal ⬅ vTBNMatrix * fixedNormal
        fragmentScope ✍ fixedNormal ⬅ ^fixedNormal
        
        // Phong factors
        let ndl = Variable<GLSLFloat>(name: "ndl")
        fragmentScope ✍ ndl ⬅ fixedNormal ⋅ lightVersor
        let ndh = Variable<GLSLFloat>(name: "ndh")
        fragmentScope ✍ ndh ⬅ fixedNormal ⋅ halfVersor
        
        // Diffuse color
        let colorMapSample: Evaluation<GLSLColor> = uColorMap ☒ vTexel
        let diffuseColor = Variable<GLSLColor>(name: "diffuseColor")
        fragmentScope ✍ fullDiffuseColor ⬅ lightColor * colorMapSample
        fragmentScope ✍ diffuseColor ⬅ fullDiffuseColor * ndl
        
        // Specular color
        let specularPower = Variable<GLSLFloat>(name: "specularPower")
        let specularWidth = Variable<GLSLFloat>(name: "specularWidth")
        let specularColor = Variable<GLSLColor>(name: "specularColor")
        fragmentScope ✍ specularPower ⬅ vSpecularPower * specularSample
        fragmentScope ✍ specularWidth ⬅ vSpecularWidth * specularSample
        fragmentScope ✍ specularColor ⬅ lightColor * ((ndh ^ specularPower) * specularWidth)
        
//        fragmentScope ✍  ⬅ 
        
        fragmentScope ✍ OpenGLDefaultVariables.glFragColor() ⬅ (specularColor + diffuseColor)
        
        var program = SmartPipelineProgram(vertexScope: vertexScope, fragmentScope: fragmentScope)
//        NSLog("\n" + GLSLParser.scope(program.pipeline.vertexShader.function.scope!))
        NSLog("\n" + GLSLParser.scope(program.pipeline.fragmentShader.function.scope!))
//        program.compile()
//        NSLog("")
        return program
    }
}