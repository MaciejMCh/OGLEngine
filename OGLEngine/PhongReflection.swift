//
//  PhongReflection.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

extension DefaultScopes {

    static func PhongHalfVersor(
        lightVersor: GPUVariable<GLSLVec3>,
        modelPosition: GPUVariable<GLSLVec3>,
        eyePosition: GPUVariable<GLSLVec3>,
        viewVersor: GPUVariable<GLSLVec3>,
        halfVersor: GPUVariable<GLSLVec3>
        ) -> GPUScope {
        let scope = GPUScope()
        
        scope ✍ viewVersor ⬅ (eyePosition - modelPosition)
        scope ✍ viewVersor ⬅ ^viewVersor
        scope ✍ halfVersor ⬅ (lightVersor + viewVersor)
        scope ✍ halfVersor ⬅ ^halfVersor
        
        return scope
    }
    
    static func PhongFactorsScope(
        normalVector: GPUVariable<GLSLVec3>,
        lightVector: GPUVariable<GLSLVec3>,
        halfVector: GPUVariable<GLSLVec3>,
        ndl: GPUVariable<GLSLFloat>,
        ndh: GPUVariable<GLSLFloat>
        ) -> GPUScope {
        let scope = GPUScope()
        
        scope ✍ ndl ⬅ normalVector ⋅ lightVector
        scope ✍ ndh ⬅ normalVector ⋅ halfVector
        
        return scope
    }
    
    static func PhongReflectionColorScope(
        normalVector: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "normalVector"),
        lightVector: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "lightVector"),
        halfVector: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "halfVector"),
        fullDiffuseColor: GPUVariable<GLSLColor> = GPUVariable<GLSLColor>(name: "fullDiffuseColor"),
        lightColor: GPUVariable<GLSLColor> = GPUVariable<GLSLColor>(name: "lightColor"),
        shininess: GPUVariable<GLSLFloat> = GPUVariable<GLSLFloat>(name: "shininess"),
        phongColor: GPUVariable<GLSLColor> = GPUVariable<GLSLColor>(name: "phongColor")
        ) -> GPUScope {
        
        let scope = GPUScope()
        let ndl = GPUVariable<GLSLFloat>(name: "ndl")
        let ndh = GPUVariable<GLSLFloat>(name: "ndh")
        let reflectionPower = GPUVariable<GLSLFloat>(name: "reflectionPower")
        let phongFactorsScope = DefaultScopes.PhongFactorsScope(normalVector,
                                                                lightVector: lightVector,
                                                                halfVector: halfVector,
                                                                ndl: ndl,
                                                                ndh: ndh)
        
        let diffuseColor = GPUVariable<GLSLColor>(name: "diffuseColor")
        let specularColor = GPUVariable<GLSLColor>(name: "specularColor")
        
        scope ↳↘ ndl
        scope ↳↘ ndh
        scope ↳↘ reflectionPower
        scope ↳↘ diffuseColor
        scope ↳↘ specularColor
        scope ⎘ phongFactorsScope
        scope ✍ diffuseColor ⬅ fullDiffuseColor * ndl
        scope ✍ reflectionPower ⬅ (ndh ^ shininess)
        scope ✍ specularColor ⬅ lightColor * reflectionPower
        scope ✍ phongColor ⬅ diffuseColor ✖ specularColor
        
        return scope
    }
    
    static func AdvancedPhongReflectionColorScope(
        normalVector: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "normalVector"),
        lightVector: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "lightVector"),
        halfVector: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "halfVector"),
        fullDiffuseColor: GPUVariable<GLSLColor> = GPUVariable<GLSLColor>(name: "fullDiffuseColor"),
        lightColor: GPUVariable<GLSLColor> = GPUVariable<GLSLColor>(name: "lightColor"),
        specularSample: GPUVariable<GLSLFloat> = GPUVariable<GLSLFloat>(name: "specularSample"),
        specularPower: GPUVariable<GLSLFloat> = GPUVariable<GLSLFloat>(name: "specularPower"),
        specularWidth: GPUVariable<GLSLFloat> = GPUVariable<GLSLFloat>(name: "specularWidth"),
        ambiencePower: GPUVariable<GLSLFloat> = GPUVariable<GLSLFloat>(name: "ambiencePower"),
        phongColor: GPUVariable<GLSLColor> = GPUVariable<GLSLColor>(name: "phongColor")
        ) -> GPUScope {
        
        let scope = GPUScope()
        let ndl = GPUVariable<GLSLFloat>(name: "ndl")
        let ndh = GPUVariable<GLSLFloat>(name: "ndh")
        let shininess = GPUVariable<GLSLFloat>(name: "shininess")
        let reflectionPower = GPUVariable<GLSLFloat>(name: "reflectionPower")
        let phongFactorsScope = DefaultScopes.PhongFactorsScope(normalVector,
                                                                lightVector: lightVector,
                                                                halfVector: halfVector,
                                                                ndl: ndl,
                                                                ndh: ndh)
        
        let diffuseColor = GPUVariable<GLSLColor>(name: "diffuseColor")
        let specularColor = GPUVariable<GLSLColor>(name: "specularColor")
        let ambientColor = GPUVariable<GLSLColor>(name: "ambientColor")
        
        scope ↳↘ ndl
        scope ↳↘ ndh
        scope ↳↘ reflectionPower
        scope ↳↘ diffuseColor
        scope ↳↘ specularColor
        scope ↳↘ ambientColor
        scope ⎘ phongFactorsScope
        scope ↳↘ shininess
        scope ✍ shininess ⬅ specularSample * specularPower
        scope ✍ diffuseColor ⬅ fullDiffuseColor * ndl
        scope ✍ reflectionPower ⬅ (ndh ^ shininess)
        scope ✍ reflectionPower ⬅ reflectionPower * specularWidth
        scope ✍ specularColor ⬅ lightColor * reflectionPower
        scope ✍ ambientColor ⬅ lightColor * ambiencePower
        scope ✍ phongColor ⬅ diffuseColor ✖ specularColor
        scope ✍ phongColor ⬅ phongColor ✖ ambientColor
        
        return scope
    }
    
    
}