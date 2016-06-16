//
//  ReflectedPipelineProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 16.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class ReflectedPipelineProgram: PipelineProgram {
    typealias RenderableType = ReflectedRenderable
    var glName: GLuint = 0
    var pipeline = DefaultPipelines.Reflected()
    
    var camera: Camera!
    var reflectionPlane: ReflectionPlane!
    
    func willRender(renderable: RenderableType) {
        pipeline.uniform(GPUUniforms.planeSpaceModelMatrix).cpuVariableGetter = {renderable.geometryModel.modelMatrix() * invertMatrix(self.reflectionPlane.geometryModel.modelMatrix())}
        pipeline.uniform(GPUUniforms.planeSpaceViewProjectionMatrix).cpuVariableGetter = {invertMatrix(self.reflectionPlane.geometryModel.modelMatrix()) * self.camera.viewProjectionMatrix()}
    }
}