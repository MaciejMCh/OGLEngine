//
//  MediumShotProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 10.04.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class MediumShotProgram: GPUProgram {
    typealias RenderableType = MediumShotRenderable
    var shaderName: String = "MediumShot"
    var interface: GPUInterface = DefaultInterfaces.mediumShotInterface()
    var implementation: GPUImplementation = GPUImplementation(instances: [])
    var glName: GLuint = 0
    
    var camera: Camera!
    var directionalLight: DirectionalLight!
    
    func programDidCompile() {
        self.bindUniformWithPass(.LightDirection, pass: self.directionalLight)
//        self.bindUniformWithPass(.EyePosition, pass: self.camera.cameraPositionPass())
    }
    
    func render(renderables: [RenderableType]) {
        self.triggerBondPasses()
        
        for renderable in renderables {
            self.bindAttributes(renderable)
            self.bindColorMap(renderable)
//            self.bindNormalMap(renderable)
            
            self.passModelViewProjectionMatrix(renderable, camera: self.camera)
            
            self.passModelMatrix(renderable)
            self.passViewMatrix(camera)
            self.passProjectionMatrix(camera)
            
            self.draw(renderable)
            self.unbindAttributes(renderable)
        }
    }
    
    
}