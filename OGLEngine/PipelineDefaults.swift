//
//  PipelineDefaults.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 22.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

public struct OpenGLDefaultVariables {
    func glPosition() -> TypedGPUVariable<GLSLVec4> {
        return TypedGPUVariable<GLSLVec4>(name: "gl_Position")
    }
    
    func glFragColor() -> TypedGPUVariable<GLSLColor> {
        return TypedGPUVariable<GLSLColor>(name: "gl_FragColor")
    }
}

public struct DefaultScopes {
    
    public struct VertexShaders {
        public static func MediumShot() -> GPUScope {
            let scope = GPUScope()
            
            let attributesDeclarations = DefaultScopes.AttributesDeclaration.ViewSpaceCalculation()
            let phongDeclarations = DefaultScopes.FuncionalitiesDeclaration.PerModelAnglePhong()
            let modelDeclarations = DefaultScopes.FuncionalitiesDeclaration.Model()
            
            let vTexel = TypedGPUVariable<GLSLVec2>(name: "vTexel")
            let vLighDirection = TypedGPUVariable<GLSLVec3>(name: "vLighDirection")
            let vLighHalfVector = TypedGPUVariable<GLSLVec3>(name: "vLighHalfVector")
            let vNormal = TypedGPUVariable<GLSLVec3>(name: "vNormal")
            
            let vertexShaderScope = DefaultScopes.MediumShotVertexScope(
                OpenGLDefaultVariables().glPosition(),
                aPosition: attributesDeclarations.aPosition,
                aTexel: attributesDeclarations.aTexel,
                aNormal: attributesDeclarations.aNormal,
                vTexel: vTexel,
                vLighDirection: vLighDirection,
                vLighHalfVector: vLighHalfVector,
                vNormal: vNormal,
                uLighDirection: phongDeclarations.uLightVector,
                uLighHalfVector: phongDeclarations.uHalfVector,
                uNormalMatrix: modelDeclarations.uNormalMatrix,
                uModelViewProjectionMatrix: modelDeclarations.uModelViewProjectionMatrix,
                uTextureScale: Uniform.TextureScale.variable() as! TypedGPUVariable<GLSLFloat>
            )
            
            scope ⎘ attributesDeclarations.scope
            scope ⎘ phongDeclarations.uniformsScope
            scope ⎘ phongDeclarations.varyingsScope
            scope ⎘ vertexShaderScope
            
            
            let fragmentShaderScope = GPUScope()
            let fullDiffuseColor = TypedGPUVariable<GLSLColor>(name: "fullDiffuseColor")
            let lightColor = TypedGPUVariable<GLSLColor>(name: "lightColor")
            let shininess = TypedGPUVariable<GLSLFloat>(name: "shininess")
            let phongScope = DefaultScopes.PhongReflectionColorScope(vNormal, lightVector: vLighDirection, halfVector: vLighHalfVector, fullDiffuseColor: fullDiffuseColor, lightColor: lightColor, shininess: shininess, phongColor: OpenGLDefaultVariables().glFragColor())
            
            fragmentShaderScope ⎘ phongDeclarations.varyingsScope
            fragmentShaderScope ⎘ phongScope
            
            return fragmentShaderScope
        }
    }
    
    public struct AttributesDeclaration {
        
        public struct ViewSpaceCalculation {
            let aPosition = TypedGPUVariable<GLSLVec4>(name: "aPosition")
            let aTexel = TypedGPUVariable<GLSLVec2>(name: "aTexel")
            let aNormal = TypedGPUVariable<GLSLVec3>(name: "aNormal")
            var scope: GPUScope {
                let scope = GPUScope()
                
                scope ⥤ aPosition
                scope ⥤ aTexel
                scope ⥤ aNormal
                
                return scope
            }
        }
        
        public struct TangentSpaceCalculation {
            let aPosition = TypedGPUVariable<GLSLVec4>(name: "aPosition")
            let aTexel = TypedGPUVariable<GLSLVec2>(name: "aTexel")
            let aTangentMatrixCol1 = TypedGPUVariable<GLSLVec3>(name: "aTangentMatrixCol1")
            let aTangentMatrixCol2 = TypedGPUVariable<GLSLVec3>(name: "aTangentMatrixCol2")
            let aTangentMatrixCol3 = TypedGPUVariable<GLSLVec3>(name: "aTangentMatrixCol3")
            var scope: GPUScope {
                let scope = GPUScope()
                
                scope ⥤ aPosition
                scope ⥤ aTexel
                scope ⥤ aTangentMatrixCol1
                scope ⥤ aTangentMatrixCol2
                scope ⥤ aTangentMatrixCol3
                
                return scope
            }
        }
    }
    
    public struct FuncionalitiesDeclaration {
        
        public struct Model {
            let uModelMatrix = Uniform.ModelMatrix.variable() as! TypedGPUVariable<GLSLMat4>
            let uViewMatrix = Uniform.ViewMatrix.variable() as! TypedGPUVariable<GLSLMat4>
            let uProjectionMatrix = Uniform.ProjectionMatrix.variable() as! TypedGPUVariable<GLSLMat4>
            let uModelViewProjectionMatrix = Uniform.ModelViewProjectionMatrix.variable() as! TypedGPUVariable<GLSLMat4>
            let uNormalMatrix = Uniform.NormalMatrix.variable() as! TypedGPUVariable<GLSLMat3>
            
            var scope: GPUScope {
                let scope = GPUScope()
                
                scope ⥥ uModelMatrix
                scope ⥥ uViewMatrix
                scope ⥥ uProjectionMatrix
                scope ⥥ uModelViewProjectionMatrix
                scope ⥥ uNormalMatrix
                
                return scope
            }
        }
        
        public struct PerModelAnglePhong {
            let uLightVector = TypedGPUVariable<GLSLVec3>(name: "uLightVector")
            let uHalfVector = TypedGPUVariable<GLSLVec3>(name: "uHalfVector")
            
            let vLightVector = TypedGPUVariable<GLSLVec3>(name: "vLightVector")
            let vHalfVector = TypedGPUVariable<GLSLVec3>(name: "vHalfVector")
            let vWorldSpaceNormal = TypedGPUVariable<GLSLVec3>(name: "vWorldSpaceNormal")
            
            var varyingsScope: GPUScope {
                let scope = GPUScope()
                
                scope ⟿ vLightVector
                scope ⟿ vHalfVector
                scope ⟿ vWorldSpaceNormal
                
                return scope
            }
            
            var uniformsScope: GPUScope {
                let scope = GPUScope()
                
                scope ⥥ uLightVector
                scope ⥥ uHalfVector
                
                return scope
            }
        }
        
        public struct PerPixelAnglePhong {
            let uLightVector = TypedGPUVariable<GLSLVec3>(name: "uLightVector")
            let uEyePosition = TypedGPUVariable<GLSLVec3>(name: "uEyePosition")
            let vWorldSpaceNormal = TypedGPUVariable<GLSLVec3>(name: "vWorldSpaceNormal")
            let vHalfVector = TypedGPUVariable<GLSLVec3>(name: "vHalfVector")
            let vLightVector = TypedGPUVariable<GLSLVec3>(name: "vLightVector")
            let worldSpacePosition = TypedGPUVariable<GLSLVec3>(name: "worldSpacePosition")
            
            var varyingsScope: GPUScope {
                let scope = GPUScope()
                
                scope ⟿ vLightVector
                scope ⟿ vHalfVector
                scope ⟿ vWorldSpaceNormal
                
                return scope
            }
            
            var uniformsScope: GPUScope {
                let scope = GPUScope()
                
                scope ⥥ uLightVector
                scope ⥥ uEyePosition
                
                return scope
            }
        }
        
        
    }
    
    static func MediumShotVertexScope(
        glPosition: TypedGPUVariable<GLSLVec4>,
        
        aPosition: TypedGPUVariable<GLSLVec4>,
        aTexel: TypedGPUVariable<GLSLVec2>,
        aNormal: TypedGPUVariable<GLSLVec3>,
        
        vTexel: TypedGPUVariable<GLSLVec2>,
        vLighDirection: TypedGPUVariable<GLSLVec3>,
        vLighHalfVector: TypedGPUVariable<GLSLVec3>,
        vNormal: TypedGPUVariable<GLSLVec3>,
        
        uLighDirection: TypedGPUVariable<GLSLVec3>,
        uLighHalfVector: TypedGPUVariable<GLSLVec3>,
        uNormalMatrix: TypedGPUVariable<GLSLMat3>,
        uModelViewProjectionMatrix: TypedGPUVariable<GLSLMat4>,
        uTextureScale: TypedGPUVariable<GLSLFloat>
        ) -> GPUScope {
        let scope = GPUScope()
        let scaledTexel = TypedGPUVariable<GLSLVec2>(name: "scaledTexel")
        
        scope ✍ scaledTexel ⬅ aTexel * uTextureScale
        scope ✍ vTexel ⬅ scaledTexel
        scope ✍ vLighDirection ⬅ uLighDirection
        scope ✍ vLighHalfVector ⬅ uLighHalfVector
        scope ✍ vNormal ⬅ uNormalMatrix * aNormal
        scope ✍ vNormal ⬅ ^vNormal
        scope ✍ glPosition ⬅ uModelViewProjectionMatrix * aPosition
        
        return scope
    }
    
    static func PhongFactorsScope(
        normalVector: TypedGPUVariable<GLSLVec3>,
        lightVector: TypedGPUVariable<GLSLVec3>,
        halfVector: TypedGPUVariable<GLSLVec3>,
        ndl: TypedGPUVariable<GLSLFloat>,
        ndh: TypedGPUVariable<GLSLFloat>
        ) -> GPUScope {
        let scope = GPUScope()
        
        scope ✍ ndl ⬅ normalVector ⋅ lightVector
        scope ✍ ndh ⬅ normalVector ⋅ halfVector
        
        return scope
    }
    
    static func PhongReflectionColorScope(
        normalVector: TypedGPUVariable<GLSLVec3> = TypedGPUVariable<GLSLVec3>(name: "normalVector"),
        lightVector: TypedGPUVariable<GLSLVec3> = TypedGPUVariable<GLSLVec3>(name: "lightVector"),
        halfVector: TypedGPUVariable<GLSLVec3> = TypedGPUVariable<GLSLVec3>(name: "halfVector"),
        fullDiffuseColor: TypedGPUVariable<GLSLColor> = TypedGPUVariable<GLSLColor>(name: "fullDiffuseColor"),
        lightColor: TypedGPUVariable<GLSLColor> = TypedGPUVariable<GLSLColor>(name: "lightColor"),
        shininess: TypedGPUVariable<GLSLFloat> = TypedGPUVariable<GLSLFloat>(name: "shininess"),
        phongColor: TypedGPUVariable<GLSLColor> = TypedGPUVariable<GLSLColor>(name: "phongColor")
        ) -> GPUScope {
        let scope = GPUScope()
        
        let ndl = TypedGPUVariable<GLSLFloat>(name: "ndl")
        let ndh = TypedGPUVariable<GLSLFloat>(name: "ndh")
        let reflectionPower = TypedGPUVariable<GLSLFloat>(name: "reflectionPower")
        let phongFactorsScope = DefaultScopes.PhongFactorsScope(normalVector, lightVector: lightVector, halfVector: halfVector, ndl: ndl, ndh: ndh)
        let diffuseColor = TypedGPUVariable<GLSLColor>(name: "diffuseColor")
        let specularColor = TypedGPUVariable<GLSLColor>(name: "specularColor")
        
        scope ⎘ phongFactorsScope
        scope ✍ diffuseColor ⬅ fullDiffuseColor * ndl
        scope ✍ reflectionPower ⬅ (ndh ^ shininess)
        scope ✍ specularColor ⬅ lightColor * reflectionPower
        scope ✍ phongColor ⬅ diffuseColor ✖ specularColor
        
        return scope
    }
    
}

public struct DefaultPipelines {
    static func mediumShotPipeline() -> GPUPipeline {
        let varyings = [GPUVarying(variable: TypedGPUVariable<GLKVector2>(name: "vTexel"), type: .Vec2, precision: .Low)]
        let vertexShader = VertexShader(
            name: "Medium Shot",
            attributes: [.Position, .Texel, .Normal],
            uniforms: [.ModelViewProjectionMatrix],
            varyings: varyings,
            function: GPUFunctions.mediumShotVertex())
        let fragmentShader = FragmentShader(
            name: "Medium Shot",
            uniforms: [.ColorMap],
            varyings: [],
            function: GPUFunctions.mediumShotFragment())
        return GPUPipeline(vertexShader: vertexShader, fragmentShader: fragmentShader)
    }
}

public struct GPUFunctions {
    
    static func mediumShotVertex() -> TypedGPUFunction<Void> {
        let scope = GPUScope()
        
        let vTexel = TypedGPUVariable<GLKVector2>(name: "vTexel")
        let uTexel = TypedGPUVariable<GLKVector2>(name: "uTexel")
        let glPosition = TypedGPUVariable<GLKVector4>(name: "gl_Position")
        let aPosition = TypedGPUVariable<GLKVector4>(name: "aPosition")
        let uModelViewProjectionMatrix = TypedGPUVariable<GLKMatrix4>(name: "uModelViewProjectionMatrix")
        
        scope ✍ vTexel ⬅ uTexel
        scope ✍ glPosition ⬅ uModelViewProjectionMatrix * aPosition
        
        return TypedGPUFunction<Void>(signature: "main", input: [], scope: scope)
    }
    
    static func mediumShotFragment() -> TypedGPUFunction<Void> {
        return TypedGPUFunction<Void>()
    }
    
    static func phongFactors() -> TypedGPUFunction<PhongFactors> {
        let output = TypedGPUVariable<PhongFactors>()
        let input = [TypedGPUVariable<GLSLVec3>(), TypedGPUVariable<GLSLVec3>(), TypedGPUVariable<GLSLVec3>()]
        
        let lightVector = input[0]
        let halfVector = input[1]
        let normalVector = input[2]
        
        let scope = GPUScope()
        let ndl = TypedGPUVariable<GLSLFloat>(name: "ndl")
        let ndh = TypedGPUVariable<GLSLFloat>(name: "ndh")
        
        scope ✍ ndl ⬅ normalVector ⋅ lightVector
        scope ✍ ndh ⬅ normalVector ⋅ halfVector
        scope ✍ output ⬅ ⇅PhongFactors(ndl: ndl, ndh: ndh)
        return TypedGPUFunction<PhongFactors>(input: input, output: output, scope: scope)
    }
}
