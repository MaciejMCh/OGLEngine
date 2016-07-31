//
//  Renderer.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 16.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

struct Renderer {
    static var closeShotProgram: CloseShotPipelineProgram!
    static var mediumShotProgram: MediumShotPipelineProgram!
    static var reflectiveSurfaceProgram: ReflectiveSurfacePipelineProgram!
    static var reflectedProgram: ReflectedPipelineProgram!
    static var skyBoxProgram: SkyBoxPipelineProgram!
    static var frameBufferViewerProgram: FrameBufferViewerPipelineProgram!
    static var lightingIdeaImplementationProgram: SmartPipelineProgram!
    
    static func render(scene: Scene) {
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT));
        
        glUseProgram(self.skyBoxProgram.glName)
        self.skyBoxProgram.render([scene.skyBox], scene: scene)
        
        glUseProgram(self.mediumShotProgram.glName)
        self.mediumShotProgram.render(scene.mediumShots, scene: scene)
        
        glUseProgram(self.lightingIdeaImplementationProgram.glName)
        self.lightingIdeaImplementationProgram.render(scene.closeShots, scene: scene)
        
        for reflectiveSurface in scene.reflectiveSurfaces {
            reflectiveSurface.reflectionColorMap.withFbo({
                Renderer.renderReflected(scene, reflectionPlane: reflectiveSurface.reflectionPlane)
            })
        }
        
        glUseProgram(self.reflectiveSurfaceProgram.glName)
        self.reflectiveSurfaceProgram.render(scene.reflectiveSurfaces, scene: scene)
    }
    
    static func renderReflected(scene: Scene, reflectionPlane: ReflectionPlane) {
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT));
        
        glUseProgram(self.reflectedProgram.glName)
        self.reflectedProgram.camera = ReflectedCamera(camera: scene.camera as! LookAtCamera, reflectionPlane: reflectionPlane)
        self.reflectedProgram.reflectionPlane = reflectionPlane
        self.reflectedProgram.render(scene.reflecteds(), scene: scene)
    }
    
    static func renderRayBox(scene: Scene, camera: Camera) {
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT));
        renderRayWall(.Left, scene: scene, camera: camera)
        renderRayWall(.Forward, scene: scene, camera: camera)
        renderRayWall(.Back, scene: scene, camera: camera)
        renderRayWall(.Right, scene: scene, camera: camera)
        renderRayWall(.Down, scene: scene, camera: camera)
        renderRayWall(.Up, scene: scene, camera: camera)
    }
    
    static func renderRayWall(focusDirection: FocusDirection, scene: Scene, camera: Camera) {
        let rayCamera = RayBoxCamera(eyePosition: camera.cameraPosition())
        rayCamera.lookAt(focusDirection)
        var rayScene = scene
        rayScene.camera = rayCamera
        focusDirection.applyViewPort()

        glClear(GLbitfield(GL_DEPTH_BUFFER_BIT));
        glUseProgram(self.skyBoxProgram.glName)
        self.skyBoxProgram.render([scene.skyBox], scene: rayScene)
    }
    
    static func renderFrameBufferPreview(scene: Scene) {
        
        self.frameBufferViewerProgram.renderable.frameBufferRenderedTexture.withFbo {
            Renderer.renderRayBox(scene, camera: scene.camera)
        }
        
        glUseProgram(self.frameBufferViewerProgram.glName)
        self.frameBufferViewerProgram.render([self.frameBufferViewerProgram.renderable], scene: scene)
    }
    
}