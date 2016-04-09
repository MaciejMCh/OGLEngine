//
//  CloseShotProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 29.03.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class CloseShotProgram: GPUProgram {
    typealias RenderableType = FinalRenderable
    var shaderName: String = "Shader"
    var interface: GPUInterface = DefaultInterfaces.detailInterface()
    var implementation: GPUImplementation = GPUImplementation(instances: [])
    var glName: GLuint = 0
    
    var camera: Camera!
    var directionalLight: DirectionalLight!
    var normalMap: Texture!
    
    required init() {
        
    }
    
    func programDidCompile() {
        self.implementation.instances.get(.LightDirection).bindWithSceneEntityPass(self.directionalLight)
    }
    
    func render(renderables: [FinalRenderable]) {
        var eyePosition = camera.cameraPosition()
        eyePosition = GLKVector3MultiplyScalar(eyePosition, -1)
        withUnsafePointer(&eyePosition, {
            glUniform3fv(self.implementation.instances.get(.EyePosition).location, 1, UnsafePointer($0))
        })
        
        for instance in self.implementation.instances {
            instance.passToGpu()
        }
    
        for renderable in renderables {
            self.bindAttributes(renderable)
            self.bindColorMap(renderable)
            self.bindNormalMap(renderable)
            
            self.passModelMatrix(renderable)
            self.passNormalMatrix(renderable)
            self.passViewMatrix(camera)
            self.passProjectionMatrix(camera)
            
            self.draw(renderable)
            self.unbindAttributes(renderable)
        }
        
    }
    
}
