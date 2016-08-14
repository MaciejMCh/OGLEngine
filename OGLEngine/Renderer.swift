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
    static var emitterProgram: SmartPipelineProgram!
    static var cubeTextureBlurrerProgram: SmartPipelineProgram!
    
    static var skyBoxCubeMap: RenderedCubeTexture!
    static var emittersCubeMap: RenderedCubeTexture!
    
    static func render(scene: Scene) {
        Renderer.renderRayBox(skyBoxCubeMap, scene: scene, camera: scene.camera)
        Renderer.renderEmissionBox(emittersCubeMap, scene: scene, camera: scene.camera)
        
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT));
        
        glUseProgram(self.skyBoxProgram.glName)
        self.skyBoxProgram.render([scene.skyBox], scene: scene)
        glClear(GLbitfield(GL_DEPTH_BUFFER_BIT));
        
        glUseProgram(self.mediumShotProgram.glName)
        self.mediumShotProgram.render(scene.mediumShots, scene: scene)
        
        glUseProgram(self.lightingIdeaImplementationProgram.glName)
        self.lightingIdeaImplementationProgram.render(scene.idealRenderables, scene: scene)
        
        for reflectiveSurface in scene.reflectiveSurfaces {
            reflectiveSurface.reflectionColorMap.withFbo({
                Renderer.renderReflected(scene, reflectionPlane: reflectiveSurface.reflectionPlane)
            })
        }
        
        glUseProgram(self.reflectiveSurfaceProgram.glName)
        self.reflectiveSurfaceProgram.render(scene.reflectiveSurfaces, scene: scene)
        
        // Temporary to see emitter
        glUseProgram(self.emitterProgram.glName)
        self.emitterProgram.render(scene.emitterRenderables, scene: scene)
    }
    
    static func renderReflected(scene: Scene, reflectionPlane: ReflectionPlane) {
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT));
        
        glUseProgram(self.reflectedProgram.glName)
        self.reflectedProgram.camera = ReflectedCamera(camera: scene.camera as! LookAtCamera, reflectionPlane: reflectionPlane)
        self.reflectedProgram.reflectionPlane = reflectionPlane
        self.reflectedProgram.render(scene.reflecteds(), scene: scene)
    }
    
    static func renderEmissionBox(cubeTexture: RenderedCubeTexture, scene: Scene, camera: Camera) {
        glClearColor(0.0, 0.0, 0.0, 0.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT));
        renderEmissionWall(cubeTexture, textureSide: .PositiveX, scene: scene, camera: camera)
        renderEmissionWall(cubeTexture, textureSide: .NegativeX, scene: scene, camera: camera)
        renderEmissionWall(cubeTexture, textureSide: .PositiveY, scene: scene, camera: camera)
        renderEmissionWall(cubeTexture, textureSide: .NegativeY, scene: scene, camera: camera)
        renderEmissionWall(cubeTexture, textureSide: .PositiveZ, scene: scene, camera: camera)
        renderEmissionWall(cubeTexture, textureSide: .NegativeZ, scene: scene, camera: camera)
    }
    
    static func renderEmissionWall(cubeTexture: RenderedCubeTexture, textureSide: CubeTextureSide, scene: Scene, camera: Camera) {
        let rayCamera = RayBoxCamera(eyePosition: camera.cameraPosition())
        rayCamera.lookAt(textureSide)
        var rayScene = scene
        rayScene.camera = rayCamera
        
        cubeTexture.withFbo(textureSide: textureSide) {
            glUseProgram(self.emitterProgram.glName)
            self.emitterProgram.render(scene.emitterRenderables, scene: rayScene)
            glClear( GLbitfield(GL_DEPTH_BUFFER_BIT));
        }
    }
    
    static func renderRayBox(cubeTexture: RenderedCubeTexture, scene: Scene, camera: Camera) {
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT));
        renderRayWall(cubeTexture, textureSide: .PositiveX, scene: scene, camera: camera)
        renderRayWall(cubeTexture, textureSide: .NegativeX, scene: scene, camera: camera)
        renderRayWall(cubeTexture, textureSide: .PositiveY, scene: scene, camera: camera)
        renderRayWall(cubeTexture, textureSide: .NegativeY, scene: scene, camera: camera)
        renderRayWall(cubeTexture, textureSide: .PositiveZ, scene: scene, camera: camera)
        renderRayWall(cubeTexture, textureSide: .NegativeZ, scene: scene, camera: camera)
    }
    
    static func renderRayWall(cubeTexture: RenderedCubeTexture, textureSide: CubeTextureSide, scene: Scene, camera: Camera) {
        let rayCamera = RayBoxCamera(eyePosition: camera.cameraPosition())
        rayCamera.lookAt(textureSide)
        var rayScene = scene
        rayScene.camera = rayCamera
        
        cubeTexture.withFbo(textureSide: textureSide) {
            glUseProgram(self.skyBoxProgram.glName)
            self.skyBoxProgram.render([scene.skyBox], scene: rayScene)
            glClear( GLbitfield(GL_DEPTH_BUFFER_BIT));
        }
    }
    
    static func blurCubeTexture(input input: RenderedCubeTexture, output: RenderedCubeTexture, scene: Scene) {
        for side in CubeTextureSide.allSidesInOrder() {
            blurCubeTextureSide(inputCubeTexture: input, outputCubeTexture: output, side: side, scene: scene)
        }
    }
    
    static func blurCubeTextureSide(inputCubeTexture inputCubeTexture: RenderedCubeTexture, outputCubeTexture: RenderedCubeTexture, side: CubeTextureSide, scene: Scene) {
        let renderable = CubeMapBlurrer(vao: FullScreenVao.vao, renderedCubeTexture: inputCubeTexture, blurringContext: inputCubeTexture.blurringContextForSide(side))
        outputCubeTexture.withFbo(textureSide: side) {
            glClear(GLbitfield(GL_DEPTH_BUFFER_BIT));
            glUseProgram(self.cubeTextureBlurrerProgram.glName)
            self.cubeTextureBlurrerProgram.render([renderable], scene: scene)
        }
    }
    
    static func renderFrameBufferPreview(scene: Scene) {
        
//        self.frameBufferViewerProgram.renderable.frameBufferRenderedTexture.withFbo {
//            Renderer.renderRayBox(scene, camera: scene.camera)
//        }
//        
//        glUseProgram(self.frameBufferViewerProgram.glName)
//        self.frameBufferViewerProgram.render([self.frameBufferViewerProgram.renderable], scene: scene)
    }
    
}