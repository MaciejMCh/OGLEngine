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
        let attributes = GPUVariableCollection<AnyGPUAttribute>(collection: [
            GPUAttributes.position,
            GPUAttributes.texel,
            GPUAttributes.tbnCol1,
            GPUAttributes.tbnCol2,
            GPUAttributes.tbnCol3,
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
    static func PhongV2(attributes: GPUVariableCollection<AnyGPUAttribute>,
                        uniforms: GPUVariableCollection<AnyGPUUniform>,
                        interpolation: PhongV2Interpolation) -> GPUVertexShader {
        let scope = DefaultScopes.PhongV2Vertex(
            OpenGLDefaultVariables.glPosition(),
            aPosition: attributes.get(GPUAttributes.position),
            aTexel: attributes.get(GPUAttributes.texel),
            aTBNCol1: attributes.get(GPUAttributes.tbnCol1),
            aTBNCol2: attributes.get(GPUAttributes.tbnCol2),
            aTBNCol3: attributes.get(GPUAttributes.tbnCol3),
            uModelMatrix: uniforms.get(GPUUniforms.modelMatrix),
            uViewProjectionMatrix: uniforms.get(GPUUniforms.viewProjectionMatrix),
            uNormalMatrix: uniforms.get(GPUUniforms.normalMatrix),
            uEyePosition: uniforms.get(GPUUniforms.eyePosition),
            vTexel: interpolation.vTexel,
            vLightVersor: interpolation.vLightVersor,
            vHalfVersor: interpolation.vHalfVersor)
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
                                    uColorMap: uniforms.get(GPUUniforms.colorMap))))
    }
}

struct PhongV2Interpolation: GPUInterpolation {
    let vTexel: GPUVariable<GLSLVec2> = GPUVariable<GLSLVec2>(name: "vTexel")
    let vLightVersor: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "vLightVersor")
    let vHalfVersor: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "vHalfVersor")
    
    func varyings() -> [GPUVarying] {
        return[
            GPUVarying(variable: vTexel, precision: .Low),
            GPUVarying(variable: vLightVersor, precision: .Low),
            GPUVarying(variable: vHalfVersor, precision: .Low)
        ]
    }
}

extension DefaultScopes {
    static func PhongV2Vertex(
        glPosition: GPUVariable<GLSLVec4>,
        aPosition: GPUVariable<GLSLVec4>,
        aTexel: GPUVariable<GLSLVec2>,
        aTBNCol1: GPUVariable<GLSLVec3>,
        aTBNCol2: GPUVariable<GLSLVec3>,
        aTBNCol3: GPUVariable<GLSLVec3>,
        uModelMatrix: GPUVariable<GLSLMat4>,
        uViewProjectionMatrix: GPUVariable<GLSLMat4>,
        uNormalMatrix: GPUVariable<GLSLMat3>,
        uEyePosition: GPUVariable<GLSLVec3>,
        vTexel: GPUVariable<GLSLVec2>,
        vLightVersor: GPUVariable<GLSLVec3>,
        vHalfVersor: GPUVariable<GLSLVec3>
        ) -> GPUScope {
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let worldSpacePosition = GPUVariable<GLSLVec4>(name: "worldSpacePosition")
        let tbnMatrix = GPUVariable<GLSLMat3>(name: "tbnMatrix")
        
        globalScope ⥤ aPosition
        globalScope ⥤ aTexel
        globalScope ⥤ aTBNCol1
        globalScope ⥤ aTBNCol2
        globalScope ⥤ aTBNCol3
        globalScope ⥥ uModelMatrix
        globalScope ⥥ uViewProjectionMatrix
        globalScope ⥥ uNormalMatrix
        globalScope ⥥ uEyePosition
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vLightVersor
        globalScope ⟿↘ vHalfVersor
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ↳ worldSpacePosition
        mainScope ✍ worldSpacePosition ⬅ uModelMatrix * aPosition
        mainScope ✍ glPosition ⬅ uViewProjectionMatrix * worldSpacePosition
        mainScope ✍ vTexel ⬅ aTexel
        mainScope ↳ tbnMatrix
        mainScope ✍ tbnMatrix ⬅ GPUEvaluation(function: GPUFunction<GLSLMat3>(signature: "mat3", input: [aTBNCol1, aTBNCol2, aTBNCol3]))
        // Light versor
        mainScope ✍ vLightVersor ⬅ GPUVariable<GLSLVec3>(value: GLKVector3Make(0.0, 0.0, 1.0))
        mainScope ✍ vLightVersor ⬅ (tbnMatrix * vLightVersor)
        // Position vector
        let positionVector = GPUVariable<GLSLVec3>(name: "positionVector")
        mainScope ↳ positionVector
        mainScope ✍ positionVector ⬅ GPUEvaluation(function: GPUFunction(signature: "vec3", input: [worldSpacePosition]))
        // View versor
        let viewVersor = GPUVariable<GLSLVec3>(name: "viewVector")
        mainScope ↳ viewVersor
        mainScope ✍ viewVersor ⬅ (uEyePosition - positionVector)
        mainScope ✍ viewVersor ⬅ ^viewVersor
        mainScope ✍ viewVersor ⬅ (tbnMatrix * viewVersor)
        // Half versor
        mainScope ✍ vHalfVersor ⬅ (vLightVersor + viewVersor)
        mainScope ✍ vHalfVersor ⬅ ^vHalfVersor
        
        return globalScope
    }
    
    static func PhongV2Fragment(
        glFragColor: GPUVariable<GLSLColor>,
        vTexel: GPUVariable<GLSLVec2>,
        vLightVersor: GPUVariable<GLSLVec3>,
        vHalfVersor: GPUVariable<GLSLVec3>,
        uColorMap: GPUVariable<GLSLTexture>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let halfVersor = GPUVariable<GLSLVec3>(name: "halfVersor")
        let lightVersor = GPUVariable<GLSLVec3>(name: "lightVersor")
        let fixedNormal = GPUVariable<GLSLVec3>(name: "fixedNormal")
        let fullDiffuseColor = GPUVariable<GLSLColor>(name: "fullDiffuseColor")
        let lightColor = GPUVariable<GLSLColor>(name: "lightColor")
        let shininess = GPUVariable<GLSLFloat>(name: "shininess")
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
        globalScope ⥥ uColorMap
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ↳↘ lightVersor
        mainScope ✍ lightVersor ⬅ ^vLightVersor
        mainScope ↳↘ halfVersor
        mainScope ✍ halfVersor ⬅ ^vHalfVersor
        mainScope ↳↘ fullDiffuseColor
        mainScope ✍ fullDiffuseColor ⬅ uColorMap ☒ vTexel
        mainScope ↳↘ lightColor
        mainScope ✍ lightColor ⬅ GPUVariable<GLSLColor>(value: (r: 1.0, g: 1.0, b: 1.0, a: 1.0))
        mainScope ↳↘ shininess
        mainScope ✍ shininess ⬅ GPUVariable<GLSLFloat>(value: 100.0)
        mainScope ↳↘ fixedNormal
        mainScope ✍ fixedNormal ⬅ GPUVariable<GLSLVec3>(value: GLKVector3Make(0.0, 0.0, 1.0))
        mainScope ⎘ phongScope
        
        return globalScope
    }
}