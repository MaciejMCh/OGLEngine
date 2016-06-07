//
//  PhongV1PipelineProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 07.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class PhongV1PipelineProgram: PipelineProgram {
    typealias RenderableType = MediumShotRenderable
    var glName: GLuint = 0
    var pipeline = DefaultPipelines.PhongV1()
    
    var camera: Camera!
    
    func willRender(renderable: RenderableType) {
        self.pipeline.uniform(GPUUniforms.modelMatrix).cpuVariableGetter = {renderable.geometryModel.modelMatrix()}
        self.pipeline.uniform(GPUUniforms.viewMatrix).cpuVariableGetter = {self.camera.viewMatrix()}
        self.pipeline.uniform(GPUUniforms.projectionMatrix).cpuVariableGetter = {self.camera.projectionMatrix()}
        self.pipeline.uniform(GPUUniforms.normalMatrix).cpuVariableGetter = {renderable.normalMatrix()}
        self.pipeline.uniform(GPUUniforms.eyePosition).cpuVariableGetter = {self.camera.cameraPosition()}
        self.pipeline.uniform(GPUUniforms.colorMap).cpuVariableGetter = {(texture: renderable.colorMap, index: 0)}
        self.pipeline.uniform(GPUUniforms.colorMap).cpuVariableGetter = {(texture: renderable.colorMap, index: 0)}
    }
}
