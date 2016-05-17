//
//  ReflectiveSurfaceProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 16.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class ReflectiveSurfaceProgram: GPUProgram {
    typealias RenderableType = ReflectiveSurfaceRenderable
    var shaderName: String = "ReflectiveSurface"
    var interface: GPUInterface = DefaultInterfaces.reflectiveInterface()
    var implementation: GPUImplementation = GPUImplementation(instances: [])
    var glName: GLuint = 0
    
    var camera: Camera!
    var scene: Scene!
    
    init(camera: Camera, directionalLight: DirectionalLight, scene: Scene) {
        self.camera = camera;
//        self.directionalLight = directionalLight
        self.scene = scene
    }
    
    func programDidCompile() {
        
    }
    
    func render(renderables: [RenderableType]) {
        for renderable in renderables {
            
            renderable.reflectionColorMap.withFbo({ 
                Renderer.renderNonReflective(self.scene)
            })
            glUseProgram(self.glName)

            self.bindAttributes(renderable)
            self.passReflectionColorMap(renderable)
            self.passModelViewProjectionMatrix(renderable, camera: self.camera)
            self.draw(renderable)
            self.unbindAttributes(renderable)
        }
    }
}