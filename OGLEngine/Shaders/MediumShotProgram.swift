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
    }
    
    func render(renderables: [RenderableType]) {
        self.triggerBondPasses()
        
        for renderable in renderables {
            self.bindAttributes(renderable)
            self.bindColorMap(renderable)
            self.passLightHalfVector(renderable, camera: self.camera, light: self.directionalLight)
            self.passModelViewProjectionMatrix(renderable, camera: self.camera)
            self.passNormalMatrix(renderable)
            self.draw(renderable)
            self.unbindAttributes(renderable)
        }
    }
    
    
}