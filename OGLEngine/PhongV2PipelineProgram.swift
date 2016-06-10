//
//  PhongV2PipelineProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 07.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

import GLKit

class PhongV2PipelineProgram: PipelineProgram {
    typealias RenderableType = CloseShotRenderable
    var glName: GLuint = 0
    var pipeline = DefaultPipelines.PhongV2()
    
    var camera: Camera!
    
    func willRender(renderable: RenderableType) {
        self.pipeline.uniform(GPUUniforms.modelMatrix).cpuVariableGetter = {renderable.geometryModel.modelMatrix()}
        self.pipeline.uniform(GPUUniforms.viewProjectionMatrix).cpuVariableGetter = {self.camera.viewProjectionMatrix()}
        self.pipeline.uniform(GPUUniforms.tangentNormalMatrix).cpuVariableGetter = {renderable.tangentNormalMatrix()}
        self.pipeline.uniform(GPUUniforms.eyePosition).cpuVariableGetter = {self.camera.cameraPosition()}
        self.pipeline.uniform(GPUUniforms.colorMap).cpuVariableGetter = {(texture: renderable.colorMap, index: 0)}
        self.pipeline.uniform(GPUUniforms.colorMap).cpuVariableGetter = {(texture: renderable.colorMap, index: 0)}
    }
}
