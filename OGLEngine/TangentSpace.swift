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
        aNormal: Variable<GLSLVec3> = GPUAttributes.normal,
        aTangent: Variable<GLSLVec3> = GPUAttributes.tangent,
        uNormalMatrix: Variable<GLSLMat3> = GPUUniforms.normalMatrix,
        vTBNMatrix: Variable<GLSLMat3> = Variable(name: "vTBNMatrix")
        ) -> GPUScope {
        let scope = GPUScope()
        let normal = Variable<GLSLVec3>(name: "normal")
        let tangent = Variable<GLSLVec3>(name: "tangent")
        let bitangent = Variable<GLSLVec3>(name: "bitangent")
        let tbnMatrix = Variable<GLSLMat3>(name: "tbnMatrix")
        
        scope ↳ normal
        scope ✍ normal ⬅ ^aNormal
        scope ↳ tangent
        scope ✍ tangent ⬅ ^aTangent
        scope ↳ bitangent
        scope ✍ bitangent ⬅ normal ✖ tangent
        scope ✍ bitangent ⬅ ^bitangent
        scope ↳ tbnMatrix
        scope ✍ tbnMatrix ⬅ Function(signature: "mat3", arguments: [tangent, bitangent, normal])
        scope ✍ vTBNMatrix ⬅ uNormalMatrix * tbnMatrix
        
        return scope
    }
}
