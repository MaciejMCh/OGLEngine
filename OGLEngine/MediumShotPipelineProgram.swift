//
//  MediumShotPipelineProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 04.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class MediumShotPipelineProgram: PipelineProgram {
    typealias RenderableType = MediumShotRenderable
    var glName: GLuint = 0
    var pipeline = DefaultPipelines.MediumShot()
    
    var camera: Camera!
    var directionalLight: DirectionalLight!
    
    func willRender(renderable: RenderableType) {
        self.pipeline.uniform(GPUUniforms.modelViewProjectionMatrix).cpuVariableGetter = {
            return renderable.modelViewProjectionMatrix(self.camera)
        }
        
        self.pipeline.uniform(GPUUniforms.normalMatrix).cpuVariableGetter = {
            return renderable.normalMatrix()
        }
        
        self.pipeline.uniform(GPUUniforms.lightDirection).cpuVariableGetter = {
            return self.directionalLight.lightDirection
        }
        
        self.pipeline.uniform(GPUUniforms.lightHalfVector).cpuVariableGetter = {
            return self.directionalLight.halfVectorWithCamera(self.camera)
        }
        
        self.pipeline.uniform(GPUUniforms.textureScale).cpuVariableGetter = {
            return 1.0
        }
        
        self.pipeline.uniform(GPUUniforms.shininess).cpuVariableGetter = {
            return 100.0
        }
        
        self.pipeline.uniform(GPUUniforms.lightColor).cpuVariableGetter = {
            return (r: 1.0, g: 1.0, b: 1.0, a: 1.0)
        }
        
        self.pipeline.uniform(GPUUniforms.colorMap).cpuVariableGetter = {
            return (texture: renderable.colorMap, index: 0)
        }
    }
}
