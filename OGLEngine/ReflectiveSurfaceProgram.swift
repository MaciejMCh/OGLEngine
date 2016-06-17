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
    var shaderSource: GLSLShaderCodeSource = GLSLFileShaderCodeSource(shaderFileName: "ReflectiveSurface")
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
                Renderer.renderReflected(self.scene, reflectionPlane: renderable.reflectionPlane)
            })
            glUseProgram(self.glName)

            self.bindAttributes(renderable)
//            self.passReflectionColorMap(renderable)
            
            GPUPassFunctions.texturePass(renderable.reflectionColorMap, index: 0, location: self.implementation.instances.get(.ReflectionColorMap).location)
            
            self.passModelViewProjectionMatrix(renderable, camera: self.camera)
            self.draw(renderable)
            self.unbindAttributes(renderable)
        }
    }
}