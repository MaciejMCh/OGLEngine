//
//  TangentSpace.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 13.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

extension DefaultScopes {
    static func FragmentTBNMatrixScope(
        aNormal: GPUVariable<GLSLVec3>,
        aTangent: GPUVariable<GLSLVec3>,
        uNormalMatrix: GPUVariable<GLSLMat3>,
        vTBNMatrix: GPUVariable<GLSLMat3>
        ) -> GPUScope {
        let scope = GPUScope()
        let normal = GPUVariable<GLSLVec3>(name: "normal")
        let tangent = GPUVariable<GLSLVec3>(name: "tangent")
        let bitangent = GPUVariable<GLSLVec3>(name: "bitangent")
        let tbnMatrix = GPUVariable<GLSLMat3>(name: "tbnMatrix")
        
        scope ↳ normal
        scope ✍ normal ⬅ ^aNormal
        scope ↳ tangent
        scope ✍ tangent ⬅ ^aTangent
        scope ↳ bitangent
        scope ✍ bitangent ⬅ normal ✖ tangent
        scope ✍ bitangent ⬅ ^bitangent
        scope ↳ tbnMatrix
        scope ✍ tbnMatrix ⬅ GPUEvaluation(function: GPUFunction<GLSLMat3>(signature: "mat3", input: [tangent, bitangent, normal]))
        scope ✍ vTBNMatrix ⬅ uNormalMatrix * tbnMatrix
        
        return scope
    }
}