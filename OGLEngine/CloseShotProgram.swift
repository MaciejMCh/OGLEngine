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
    
    typealias RenderableType = CloseShotRenderable
    var shaderSource: GLSLShaderCodeSource = GLSLFileShaderCodeSource(shaderFileName: "CloseShot")
    var interface: GPUInterface = DefaultInterfaces.detailInterface()
    var implementation: GPUImplementation = GPUImplementation(instances: [])
    var glName: GLuint = 0
    
    var camera: Camera
    var directionalLight: DirectionalLight
    
    init(camera: Camera, directionalLight: DirectionalLight) {
        self.camera = camera;
        self.directionalLight = directionalLight
    }
    
    func programDidCompile() {
        self.bindUniformWithPass(.LightDirection, pass: self.directionalLight)
        self.bindUniformWithPass(.EyePosition, pass: self.camera.cameraPositionPass())
    }
    
    func render(renderables: [CloseShotRenderable]) {
        
        self.triggerBondPasses()
    
        for renderable in renderables {
            self.bindAttributes(renderable)
            self.bindColorMap(renderable)
            self.bindNormalMap(renderable)
            
            self.passModelMatrix(renderable)
            self.passViewProjectionMatrix(camera)
            self.passNormalMatrix(renderable)
            
            self.triggerPass(GetterPass<Float>(subjectGetter: { () -> Float in
                return renderable.textureScale
            }), uniform: .TextureScale)
            
            self.draw(renderable)
            self.unbindAttributes(renderable)
        }
        
    }
    
}
