//
//  CloseShotPipelineProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 04.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class CloseShotPipelineProgram: PipelineProgram {
    typealias RenderableType = CloseShotRenderable
    var glName: GLuint = 0
    var pipeline = DefaultPipelines.CloseShot()
    
    var camera: Camera!
    var directionalLight: DirectionalLight!
    
    func willRender(renderable: RenderableType) {
//        NSLog("\(directionalLight.lightDirection.x) \(directionalLight.lightDirection.y) \(directionalLight.lightDirection.z)")
        self.pipeline.uniform(GPUUniforms.lightDirection).cpuVariableGetter = {self.directionalLight.lightDirection}
        self.pipeline.uniform(GPUUniforms.modelMatrix).cpuVariableGetter = {renderable.geometryModel.modelMatrix()}
        self.pipeline.uniform(GPUUniforms.viewProjectionMatrix).cpuVariableGetter = {self.camera.viewProjectionMatrix()}
        self.pipeline.uniform(GPUUniforms.normalMatrix).cpuVariableGetter = {renderable.normalMatrix()}
        self.pipeline.uniform(GPUUniforms.eyePosition).cpuVariableGetter = {self.camera.cameraPosition()}
        self.pipeline.uniform(GPUUniforms.colorMap).cpuVariableGetter = {(texture: renderable.colorMap, index: 0)}
        self.pipeline.uniform(GPUUniforms.normalMap).cpuVariableGetter = {(texture: renderable.normalMap, index: 1)}
        self.pipeline.uniform(GPUUniforms.textureScale).cpuVariableGetter = {1.0}
        self.pipeline.uniform(GPUUniforms.lightColor).cpuVariableGetter = {(r: 1.0, g: 1.0, b:1.0, a:1.0)}
        self.pipeline.uniform(GPUUniforms.shininess).cpuVariableGetter = {100.0}
    }
}

//self.pipeline.uniform(GPUUniforms.).cpuVariableGetter = {}