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
        
        
        let phongScope = DefaultScopes.AdvancedPhongReflectionColorScope(
            fixedNormal,
            lightVector: lightVersor,
            halfVector: halfVersor,
            fullDiffuseColor: fullDiffuseColor,
            lightColor: lightColor,
            specularSample: specularSample,
            specularPower: vSpecularPower,
            specularWidth: vSpecularWidth,
            ambiencePower: vAmbiencePower,
            phongColor: OpenGLDefaultVariables.glFragColor())
        fragmentScope ✍ lightVersor ⬅ ^vLightVersor
        fragmentScope ✍ halfVersor ⬅ ^vHalfVersor
        fragmentScope ✍ fullDiffuseColor ⬅ uColorMap ☒ vTexel
        fragmentScope ✍ lightColor ⬅ vLightColor
        fragmentScope ✍ specularSample ⬅ uSpecularMap ☒ vTexel
        fragmentScope ✍ normalMapSample ⬅ uNormalMap ☒ vTexel
        fragmentScope ✍ fixedNormal ⬅ ⤺normalMapSample
        fragmentScope ✍ fixedNormal ⬅ ^fixedNormal
        fragmentScope ✍ fixedNormal ⬅ vTBNMatrix * fixedNormal
        fragmentScope ✍ fixedNormal ⬅ ^fixedNormal
        fragmentScope ⎘ phongScope
        
        var program = SmartPipelineProgram(vertexScope: vertexScope, fragmentScope: fragmentScope)
        program.compile()
    }
}