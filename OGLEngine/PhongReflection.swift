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
        lightVersor: Variable<GLSLVec3>,
        modelPosition: Variable<GLSLVec3>,
        eyePosition: Variable<GLSLVec3>,
        viewVersor: Variable<GLSLVec3>,
        halfVersor: Variable<GLSLVec3>
        ) -> GPUScope {
        let scope = GPUScope()
        
        scope ✍ viewVersor ⬅ (eyePosition - modelPosition)
        scope ✍ viewVersor ⬅ ^viewVersor
        scope ✍ halfVersor ⬅ (lightVersor + viewVersor)
        scope ✍ halfVersor ⬅ ^halfVersor
        
        return scope
    }
    
    static func PhongFactorsScope(
        normalVector: Variable<GLSLVec3>,
        lightVector: Variable<GLSLVec3>,
        halfVector: Variable<GLSLVec3>,
        ndl: Variable<GLSLFloat>,
        ndh: Variable<GLSLFloat>
        ) -> GPUScope {
        let scope = GPUScope()
        
        scope ✍ ndl ⬅ normalVector ⋅ lightVector
        scope ✍ ndh ⬅ normalVector ⋅ halfVector
        
        return scope
    }
    
    static func PhongReflectionColorScope(
        normalVector: Variable<GLSLVec3> = Variable<GLSLVec3>(name: "normalVector"),
        lightVector: Variable<GLSLVec3> = Variable<GLSLVec3>(name: "lightVector"),
        halfVector: Variable<GLSLVec3> = Variable<GLSLVec3>(name: "halfVector"),
        fullDiffuseColor: Variable<GLSLColor> = Variable<GLSLColor>(name: "fullDiffuseColor"),
        lightColor: Variable<GLSLColor> = Variable<GLSLColor>(name: "lightColor"),
        shininess: Variable<GLSLFloat> = Variable<GLSLFloat>(name: "shininess"),
        phongColor: Variable<GLSLColor> = Variable<GLSLColor>(name: "phongColor")
        ) -> GPUScope {
        
        let scope = GPUScope()
        let ndl = Variable<GLSLFloat>(name: "ndl")
        let ndh = Variable<GLSLFloat>(name: "ndh")
        let reflectionPower = Variable<GLSLFloat>(name: "reflectionPower")
        let phongFactorsScope = DefaultScopes.PhongFactorsScope(normalVector,
                                                                lightVector: lightVector,
                                                                halfVector: halfVector,
                                                                ndl: ndl,
                                                                ndh: ndh)
        
        let diffuseColor = Variable<GLSLColor>(name: "diffuseColor")
        let specularColor = Variable<GLSLColor>(name: "specularColor")
        
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
        normalVector: Variable<GLSLVec3> = Variable<GLSLVec3>(name: "normalVector"),
        lightVector: Variable<GLSLVec3> = Variable<GLSLVec3>(name: "lightVector"),
        halfVector: Variable<GLSLVec3> = Variable<GLSLVec3>(name: "halfVector"),
        fullDiffuseColor: Variable<GLSLColor> = Variable<GLSLColor>(name: "fullDiffuseColor"),
        lightColor: Variable<GLSLColor> = Variable<GLSLColor>(name: "lightColor"),
        specularSample: Variable<GLSLFloat> = Variable<GLSLFloat>(name: "specularSample"),
        specularPower: Variable<GLSLFloat> = Variable<GLSLFloat>(name: "specularPower"),
        specularWidth: Variable<GLSLFloat> = Variable<GLSLFloat>(name: "specularWidth"),
        ambiencePower: Variable<GLSLFloat> = Variable<GLSLFloat>(name: "ambiencePower"),
        phongColor: Variable<GLSLColor> = Variable<GLSLColor>(name: "phongColor")
        ) -> GPUScope {
        
        let scope = GPUScope()
        let ndl = Variable<GLSLFloat>(name: "ndl")
        let ndh = Variable<GLSLFloat>(name: "ndh")
        let shininess = Variable<GLSLFloat>(name: "shininess")
        let reflectionPower = Variable<GLSLFloat>(name: "reflectionPower")
        let phongFactorsScope = DefaultScopes.PhongFactorsScope(normalVector,
                                                                lightVector: lightVector,
                                                                halfVector: halfVector,
                                                                ndl: ndl,
                                                                ndh: ndh)
        
        let diffuseColor = Variable<GLSLColor>(name: "diffuseColor")
        let specularColor = Variable<GLSLColor>(name: "specularColor")
        let ambientColor = Variable<GLSLColor>(name: "ambientColor")
        
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