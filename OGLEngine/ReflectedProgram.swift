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
    var shaderName: String = "Reflected"
    var interface: GPUInterface = DefaultInterfaces.reflectedInterface()
    var implementation: GPUImplementation = GPUImplementation(instances: [])
    var glName: GLuint = 0
    
    var camera: Camera!
    
    func programDidCompile() {
        
    }
    
    func render(renderables: [RenderableType]) {
        for renderable in renderables {
            self.bindAttributes(renderable)
            self.bindColorMap(renderable)
            self.triggerPass(GetterPass<Float>(subjectGetter: { () -> Float in
                return renderable.textureScale
            }), uniform: .TextureScale)
            self.passModelMatrix(renderable)
            self.passViewMatrix(self.camera)
            self.passProjectionMatrix(self.camera)
            self.draw(renderable)
            self.unbindAttributes(renderable)
        }
    }
}