//
//  PhongV1.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 07.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

// Phong reflection model:
//  - World space calculations
//  - Per pixel color calculation
//  - Per pixel view vector
//  - All phong calculations in fragment shader

extension DefaultPipelines {
    static func PhongV1() -> GPUPipeline {
        let attributes = GPUVariableCollection<AnyGPUAttribute>(collection: [
            GPUAttributes.position,
            GPUAttributes.texel,
            GPUAttributes.normal
            ])
        let uniforms = GPUVariableCollection<AnyGPUUniform>(collection: [
            GPUUniform(variable: GPUUniforms.modelMatrix),
            GPUUniform(variable: GPUUniforms.viewMatrix),
            GPUUniform(variable: GPUUniforms.projectionMatrix),
            GPUUniform(variable: GPUUniforms.normalMatrix),
            GPUUniform(variable: GPUUniforms.eyePosition),
            GPUUniform(variable: GPUUniforms.colorMap)
            ])
        let interpolation = PhongV1Interpolation()
        let vertexShader = DefaultVertexShaders.PhongV1(attributes, uniforms: uniforms, interpolation: interpolation)
        let fragmentShader = DefaultFragmentShaders.PhongV1(uniforms, interpolation: interpolation)
        return GPUPipeline(vertexShader: vertexShader, fragmentShader: fragmentShader)
    }
}

extension DefaultVertexShaders {
    static func PhongV1(attributes: GPUVariableCollection<AnyGPUAttribute>,
                           uniforms: GPUVariableCollection<AnyGPUUniform>,
                           interpolation: PhongV1Interpolation) -> GPUVertexShader {
        let scope = DefaultScopes.PhongV1Vertex(
            OpenGLDefaultVariables.glPosition(),
            aPosition: attributes.get(GPUAttributes.position),
            aTexel: attributes.get(GPUAttributes.texel),
            aNormal: attributes.get(GPUAttributes.normal),
            uModelMatrix: uniforms.get(GPUUniforms.modelMatrix),
            uViewMatrix: uniforms.get(GPUUniforms.viewMatrix),
            uProjectionMatrix: uniforms.get(GPUUniforms.projectionMatrix),
            uNormalMatrix: uniforms.get(GPUUniforms.normalMatrix),
            uEyePosition: uniforms.get(GPUUniforms.eyePosition),
            vTexel: interpolation.vTexel,
            vPosition: interpolation.vPosition,
            vNormal: interpolation.vNormal,
            vEyePosition: interpolation.vEyePosition)
        return GPUVertexShader(name: "PhongV1", attributes: attributes, uniforms: uniforms, interpolation: interpolation, function: MainGPUFunction(scope: scope))
    }
}

extension DefaultFragmentShaders {
    static func PhongV1(uniforms: GPUVariableCollection<AnyGPUUniform>, interpolation: PhongV1Interpolation) -> GPUFragmentShader {
        return GPUFragmentShader(name: "PhongV1",
                                 uniforms: uniforms,
                                 interpolation: interpolation,
                                 function: MainGPUFunction(scope: DefaultScopes.PhongV1Fragment(
                                    OpenGLDefaultVariables.glFragColor(),
                                    vTexel: interpolation.vTexel,
                                    vPosition: interpolation.vPosition,
                                    vNormal: interpolation.vNormal,
                                    vEyePosition: interpolation.vEyePosition,
                                    uColorMap: uniforms.get(GPUUniforms.colorMap))))
    }
}

struct PhongV1Interpolation: GPUInterpolation {
    let vPosition: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "vPosition")
    let vTexel: GPUVariable<GLSLVec2> = GPUVariable<GLSLVec2>(name: "vTexel")
    let vNormal: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "vNormal")
    let vEyePosition: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "vEyePosition")
    
    func varyings() -> [GPUVarying] {
        return[
            GPUVarying(variable: vPosition, precision: .Low),
            GPUVarying(variable: vTexel, precision: .Low),
            GPUVarying(variable: vNormal, precision: .Low),
            GPUVarying(variable: vEyePosition, precision: .Low)
        ]
    }
}

extension DefaultScopes {
    static func PhongV1Vertex(
        glPosition: GPUVariable<GLSLVec4>,
        aPosition: GPUVariable<GLSLVec4>,
        aTexel: GPUVariable<GLSLVec2>,
        aNormal: GPUVariable<GLSLVec3>,
        uModelMatrix: GPUVariable<GLSLMat4>,
        uViewMatrix: GPUVariable<GLSLMat4>,
        uProjectionMatrix: GPUVariable<GLSLMat4>,
        uNormalMatrix: GPUVariable<GLSLMat3>,
        uEyePosition: GPUVariable<GLSLVec3>,
        vTexel: GPUVariable<GLSLVec2>,
        vPosition: GPUVariable<GLSLVec3>,
        vNormal: GPUVariable<GLSLVec3>,
        vEyePosition: GPUVariable<GLSLVec3>
        ) -> GPUScope {
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let worldSpacePosition = GPUVariable<GLSLVec4>(name: "worldSpacePosition")
        let viewProjectionMatrix = GPUVariable<GLSLMat4>(name: "viewProjectionMatrix")
        
        globalScope ⥤ aPosition
        globalScope ⥤ aTexel
        globalScope ⥤ aNormal
        globalScope ⥥ uModelMatrix
        globalScope ⥥ uViewMatrix
        globalScope ⥥ uProjectionMatrix
        globalScope ⥥ uNormalMatrix
        globalScope ⥥ uEyePosition
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vPosition
        globalScope ⟿↘ vNormal
        globalScope ⟿↘ vEyePosition
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ↳ worldSpacePosition
        mainScope ✍ worldSpacePosition ⬅ uModelMatrix * aPosition
        mainScope ↳ viewProjectionMatrix
        mainScope ✍ viewProjectionMatrix ⬅ uProjectionMatrix * uViewMatrix
        mainScope ✍ glPosition ⬅ viewProjectionMatrix * worldSpacePosition
        mainScope ✍ vTexel ⬅ aTexel
        mainScope ✍ vPosition ⬅ GPUEvaluation(function: GPUFunction(signature: "vec3", input: [worldSpacePosition]))
        mainScope ✍ vNormal ⬅ uNormalMatrix * aNormal
        mainScope ✍ vEyePosition ⬅ uEyePosition
        
        return globalScope
    }
    
    static func PhongV1Fragment(
        glFragColor: GPUVariable<GLSLColor>,
        vTexel: GPUVariable<GLSLVec2>,
        vPosition: GPUVariable<GLSLVec3>,
        vNormal: GPUVariable<GLSLVec3>,
        vEyePosition: GPUVariable<GLSLVec3>,
        uColorMap: GPUVariable<GLSLTexture>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let viewVersor = GPUVariable<GLSLVec3>(name: "viewVersor")
        let halfVersor = GPUVariable<GLSLVec3>(name: "halfVersor")
        let lightVersor = GPUVariable<GLSLVec3>(name: "lightVersor")
        let fixedNormal = GPUVariable<GLSLVec3>(name: "fixedNormal")
        let halfVectorScope = DefaultScopes.PhongHalfVersor(
            lightVersor,
            modelPosition: vPosition,
            eyePosition: vEyePosition,
            viewVersor: viewVersor,
            halfVersor: halfVersor)
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
        globalScope ⟿↘ vPosition
        globalScope ⟿↘ vNormal
        globalScope ⟿↘ vEyePosition
        globalScope ⥥ uColorMap
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ↳↘ lightVersor
        mainScope ✍ lightVersor ⬅ GPUVariable<GLSLVec3>(value: GLKVector3Make(0.0, 0.0, 1.0))
        mainScope ↳↘ viewVersor
        mainScope ↳↘ halfVersor
        mainScope ↳↘ fullDiffuseColor
        mainScope ✍ fullDiffuseColor ⬅ uColorMap ☒ vTexel
        mainScope ↳↘ lightColor
        mainScope ✍ lightColor ⬅ GPUVariable<GLSLColor>(value: (r: 1.0, g: 1.0, b: 1.0, a: 1.0))
        mainScope ↳↘ shininess
        mainScope ✍ shininess ⬅ GPUVariable<GLSLFloat>(value: 100.0)
        mainScope ↳↘ fixedNormal
        mainScope ✍ fixedNormal ⬅ ^vNormal
        mainScope ⎘ halfVectorScope
        mainScope ⎘ phongScope
        
        return globalScope
    }
}