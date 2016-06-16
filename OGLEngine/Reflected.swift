//
//  Reflected.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 16.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

extension DefaultScopes {
    static func ReflectedVertex(
        glPosition glPosition: GPUVariable<GLSLVec4>,
        aPosition: GPUVariable<GLSLVec4>,
        aTexel: GPUVariable<GLSLVec2>,
        aNormal: GPUVariable<GLSLVec3>,
        uPlaneSpaceModelMatrix: GPUVariable<GLSLMat4>,
        uPlaneModelMatrix: GPUVariable<GLSLMat4>,
        uViewProjectionMatrix: GPUVariable<GLSLMat4>,
        uTextureScale: GPUVariable<GLSLFloat>,
        vTexel: GPUVariable<GLSLVec2>,
        vPlaneDistance: GPUVariable<GLSLFloat>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let planeSpaceModelPosition = GPUVariable<GLSLVec4>(name: "planeSpaceModelPosition")
        
        globalScope ⥤ aPosition
        globalScope ⥤ aTexel
        globalScope ⥤ aNormal
        globalScope ⥥ uPlaneSpaceModelMatrix
        globalScope ⥥ uPlaneModelMatrix
        globalScope ⥥ uViewProjectionMatrix
        globalScope ⥥ uTextureScale
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vPlaneDistance
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ✍ vTexel ⬅ aTexel * uTextureScale
        mainScope ✍ planeSpaceModelPosition ⬅ uPlaneSpaceModelMatrix * aPosition
        mainScope ✍ vPlaneDistance ⬅ FixedGPUEvaluation(glslCode: "\(planeSpaceModelPosition.name!).z")
//        mainScope ✍ glPosition ⬅ 
        
        return globalScope
    }
}

//void main() {
//    vTexel = aTexel * uTextureScale;
//    vec4 modelSpacePosition = uModelMatrix * aPosition;
//    vZPosition = modelSpacePosition.z;
//    modelSpacePosition = uModelMatrix2 * modelSpacePosition;
//    vec4 position = uViewProjectionMatrix * modelSpacePosition;
//    gl_Position = position;
//}