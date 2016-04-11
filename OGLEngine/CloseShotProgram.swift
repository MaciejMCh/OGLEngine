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
    var shaderName: String = "CloseShot"
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
            self.passViewMatrix(camera)
            self.passProjectionMatrix(camera)
            
            self.draw(renderable)
            self.unbindAttributes(renderable)
        }
        
    }
    
}
