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
        self.pipeline.uniform(GPUUniforms.lightDirection).cpuVariableGetter = {
            return self.directionalLight.lightDirection
        }
        self.pipeline.uniform(GPUUniforms.lightHalfVector).cpuVariableGetter = {
            return self.directionalLight.halfVectorWithCamera(self.camera)
        }
        self.pipeline.uniform(GPUUniforms.modelMatrix).cpuVariableGetter = {
            return renderable.geometryModel.modelMatrix()
        }
        self.pipeline.uniform(GPUUniforms.viewMatrix).cpuVariableGetter = {
            return self.camera.viewMatrix()
        }
        self.pipeline.uniform(GPUUniforms.projectionMatrix).cpuVariableGetter = {
            return self.camera.projectionMatrix()
        }
        
    }
}

//self.pipeline.uniform(GPUUniforms.).cpuVariableGetter = {
//    
//}