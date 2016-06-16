//
//  ReflectedProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 18.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class ReflectedProgram: GPUProgram {
    typealias RenderableType = ReflectedRenderable
    var shaderSource: GLSLShaderCodeSource = GLSLFileShaderCodeSource(shaderFileName: "Reflected")
    var interface: GPUInterface = DefaultInterfaces.reflectedInterface()
    var implementation: GPUImplementation = GPUImplementation(instances: [])
    var glName: GLuint = 0
    
    var camera: Camera!
    
    var reflectionPlane: ReflectionPlane!
    
    func programDidCompile() {
        
    }
    
    func render(renderables: [RenderableType]) {
        for renderable in renderables {
            self.bindAttributes(renderable)
            self.bindColorMap(renderable)
            self.triggerPass(GetterPass<Float>(subjectGetter: { () -> Float in
                return renderable.textureScale
            }), uniform: .TextureScale)
            
            var modelMatrix2 = invertMatrix(reflectionPlane.geometryModel.modelMatrix())
            withUnsafePointer(&modelMatrix2, {
                glUniformMatrix4fv(self.implementation.instances.get(.ModelMatrix2).location, 1, 0, UnsafePointer($0))
            })
            
            
            var modelMatrix = renderable.geometryModel.modelMatrix() * invertMatrix(reflectionPlane.geometryModel.modelMatrix())
            withUnsafePointer(&modelMatrix, {
                glUniformMatrix4fv(self.implementation.instances.get(.ModelMatrix).location, 1, 0, UnsafePointer($0))
            })
            
            
            self.passViewProjectionMatrix(self.camera)
            self.draw(renderable)
            self.unbindAttributes(renderable)
        }
    }
}