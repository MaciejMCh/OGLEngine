//
//  PhongV2.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 07.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

// Phong reflection model:
//  - Tangent space calculations
//  - Per pixel color calculation
//  - Per pixel view vector
//  - All phong calculations in fragment shader

extension DefaultPipelines {
    static func PhongV2() -> GPUPipeline {
        let attributes = GPUAttributesCollection(collection: [
            GPUAttributes.position,
            GPUAttributes.texel,
            GPUAttributes.normal,
            GPUAttributes.tangent,
            ])
        let uniforms = GPUVariableCollection<AnyGPUUniform>(collection: [
            GPUUniform(variable: GPUUniforms.modelMatrix),
            GPUUniform(variable: GPUUniforms.viewProjectionMatrix),
            GPUUniform(variable: GPUUniforms.normalMatrix),
            GPUUniform(variable: GPUUniforms.eyePosition),
            GPUUniform(variable: GPUUniforms.colorMap)
            ])
        let interpolation = PhongV2Interpolation()
        let vertexShader = DefaultVertexShaders.PhongV2(attributes, uniforms: uniforms, interpolation: interpolation)
        let fragmentShader = DefaultFragmentShaders.PhongV2(uniforms, interpolation: interpolation)
        return GPUPipeline(vertexShader: vertexShader, fragmentShader: fragmentShader)
    }
}

extension DefaultVertexShaders {
    static func PhongV2(attributes: GPUAttributesCollection,
                        uniforms: GPUVariableCollection<AnyGPUUniform>,
                        interpolation: PhongV2Interpolation) -> GPUVertexShader {
        let scope = DefaultScopes.PhongV2Vertex(
            OpenGLDefaultVariables.glPosition(),
            aPosition: attributes.get(GPUAttributes.position),
            aTexel: attributes.get(GPUAttributes.texel),
            aNormal: attributes.get(GPUAttributes.normal),
            aTangent: attributes.get(GPUAttributes.tangent),
            uModelMatrix: uniforms.get(GPUUniforms.modelMatrix),
            uViewProjectionMatrix: uniforms.get(GPUUniforms.viewProjectionMatrix),
            uNormalMatrix: uniforms.get(GPUUniforms.normalMatrix),
            uEyePosition: uniforms.get(GPUUniforms.eyePosition),
            vTexel: interpolation.vTexel,
            vLightVersor: interpolation.vLightVersor,
            vHalfVersor: interpolation.vHalfVersor,
            vTBNMatrix: interpolation.vTBNMatrix)
        return GPUVertexShader(name: "PhongV2", attributes: attributes, uniforms: uniforms, interpolation: interpolation, function: MainGPUFunction(scope: scope))
    }
}

extension DefaultFragmentShaders {
    static func PhongV2(uniforms: GPUVariableCollection<AnyGPUUniform>, interpolation: PhongV2Interpolation) -> GPUFragmentShader {
        return GPUFragmentShader(name: "PhongV2",
                                 uniforms: uniforms,
                                 interpolation: interpolation,
                                 function: MainGPUFunction(scope: DefaultScopes.PhongV2Fragment(
                                    OpenGLDefaultVariables.glFragColor(),
                                    vTexel: interpolation.vTexel,
                                    vLightVersor: interpolation.vLightVersor,
                                    vHalfVersor: interpolation.vHalfVersor,
                                    vTBNMatrix: interpolation.vTBNMatrix,
                                    uColorMap: uniforms.get(GPUUniforms.colorMap))))
    }
}

struct PhongV2Interpolation: GPUInterpolation {
    let vTexel: Variable<GLSLVec2> = Variable<GLSLVec2>(name: "vTexel")
    let vLightVersor: Variable<GLSLVec3> = Variable<GLSLVec3>(name: "vLightVersor")
    let vHalfVersor: Variable<GLSLVec3> = Variable<GLSLVec3>(name: "vHalfVersor")
    let vTBNMatrix: Variable<GLSLMat3> = Variable<GLSLMat3>(name: "vTBNMatrix")
    
    func varyings() -> [GPUVarying] {
        return[
            GPUVarying(variable: vTexel, precision: .Low),
            GPUVarying(variable: vLightVersor, precision: .Low),
            GPUVarying(variable: vHalfVersor, precision: .Low),
            GPUVarying(variable: vTBNMatrix, precision: .Low),
        ]
    }
}

extension DefaultScopes {
    static func PhongV2Vertex(
        glPosition: Variable<GLSLVec4>,
        aPosition: Variable<GLSLVec3>,
        aTexel: Variable<GLSLVec2>,
        aNormal: Variable<GLSLVec3>,
        aTangent: Variable<GLSLVec3>,
        uModelMatrix: Variable<GLSLMat4>,
        uViewProjectionMatrix: Variable<GLSLMat4>,
        uNormalMatrix: Variable<GLSLMat3>,
        uEyePosition: Variable<GLSLVec3>,
        vTexel: Variable<GLSLVec2>,
        vLightVersor: Variable<GLSLVec3>,
        vHalfVersor: Variable<GLSLVec3>,
        vTBNMatrix: Variable<GLSLMat3>
        ) -> GPUScope {
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let worldSpacePosition = Variable<GLSLVec4>(name: "worldSpacePosition")
        let tbnScope = DefaultScopes.FragmentTBNMatrixScope(aNormal, aTangent: aTangent, uNormalMatrix: uNormalMatrix, vTBNMatrix: vTBNMatrix)
        let viewVersor = Variable<GLSLVec3>(name: "viewVector")
        let positionVector = Variable<GLSLVec3>(name: "positionVector")
        let halfVersorScope = DefaultScopes.PhongHalfVersor(vLightVersor, modelPosition: positionVector, eyePosition: uEyePosition, viewVersor: viewVersor, halfVersor: vHalfVersor)
        
        globalScope ⥤ aPosition
        globalScope ⥤ aTexel
        globalScope ⥤ aNormal
        globalScope ⥤ aTangent
        globalScope ⥥ uModelMatrix
        globalScope ⥥ uViewProjectionMatrix
        globalScope ⥥ uNormalMatrix
        globalScope ⥥ uEyePosition
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vLightVersor
        globalScope ⟿↘ vHalfVersor
        globalScope ⟿↘ vTBNMatrix
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ↳ worldSpacePosition
        mainScope ✍ worldSpacePosition ⬅ uModelMatrix * aPosition
        mainScope ✍ glPosition ⬅ uViewProjectionMatrix * worldSpacePosition
        mainScope ✍ vTexel ⬅ aTexel
        mainScope ✍ vLightVersor ⬅ Primitive<GLSLVec3>(value: GLKVector3Make(0.0, 0.0, 1.0))
        mainScope ↳ positionVector
        mainScope ✍ positionVector ⬅ VecInits.vec3(worldSpacePosition)
        mainScope ⎘ tbnScope
        mainScope ↳ viewVersor
        mainScope ⎘ halfVersorScope
        
        return globalScope
    }
    
    static func PhongV2Fragment(
        glFragColor: Variable<GLSLColor>,
        vTexel: Variable<GLSLVec2>,
        vLightVersor: Variable<GLSLVec3>,
        vHalfVersor: Variable<GLSLVec3>,
        vTBNMatrix: Variable<GLSLMat3>,
        uColorMap: Variable<GLSLTexture>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let halfVersor = Variable<GLSLVec3>(name: "halfVersor")
        let lightVersor = Variable<GLSLVec3>(name: "lightVersor")
        let fixedNormal = Variable<GLSLVec3>(name: "fixedNormal")
        let fullDiffuseColor = Variable<GLSLColor>(name: "fullDiffuseColor")
        let lightColor = Variable<GLSLColor>(name: "lightColor")
        let shininess = Variable<GLSLFloat>(name: "shininess")
        let phongScope = DefaultScopes.PhongReflectionColorScope(
            fixedNormal,
            lightVector: lightVersor,
            halfVector: halfVersor,
            fullDiffuseColor: fullDiffuseColor,
            lightColor: lightColor,
            shininess: shininess,
            phongColor: glFragColor)
        
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vLightVersor
        globalScope ⟿↘ vHalfVersor
        globalScope ⟿↘ vTBNMatrix
        globalScope ⥥ uColorMap
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ↳↘ lightVersor
        mainScope ✍ lightVersor ⬅ ^vLightVersor
        mainScope ↳↘ halfVersor
        mainScope ✍ halfVersor ⬅ ^vHalfVersor
        mainScope ↳↘ fullDiffuseColor
        mainScope ✍ fullDiffuseColor ⬅ uColorMap ☒ vTexel
        mainScope ↳↘ lightColor
        mainScope ✍ lightColor ⬅ Primitive<GLSLColor>(value: (r: 1.0, g: 1.0, b: 1.0, a: 1.0))
        mainScope ↳↘ shininess
        mainScope ✍ shininess ⬅ Primitive<GLSLFloat>(value: 100.0)
        mainScope ↳↘ fixedNormal
        mainScope ✍ fixedNormal ⬅ Primitive<GLSLVec3>(value: GLKVector3Make(0.0, 0.0, 1.0))
        mainScope ✍ fixedNormal ⬅ ^fixedNormal
        mainScope ✍ fixedNormal ⬅ vTBNMatrix * fixedNormal
        mainScope ✍ fixedNormal ⬅ ^fixedNormal
        mainScope ⎘ phongScope
        
        return globalScope
    }
}