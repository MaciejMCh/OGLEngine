//
//  FrameBufferViewerPipelineProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 06.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class FrameBufferViewerPipelineProgram: PipelineProgram {
    typealias RenderableType = FrameBufferViewerRenderable
    var glName: GLuint = 0
    var pipeline = DefaultPipelines.FrameBufferViewer()
    var renderable: FrameBufferViewerRenderable!
    
    init() {
        self.renderable = FrameBufferViewerRenderable(
            vao: VAO(obj: OBJLoader.objFromFileNamed("preview")),
            frameBufferRenderedTexture: RenderedTexture())
    }
    
    func willRender(renderable: RenderableType, scene: Scene) {
//        let g: () -> RenderableType.CP = {
//            return (texture: renderable.frameBufferRenderedTexture, location: 0)
//        }
        self.pipeline.uniform(GPUUniforms.colorMap).cpuVariableGetter = {(texture: renderable.frameBufferRenderedTexture, index: 0)}
//        pipeline.uniform(GPUUniforms.colorMap).cpuVariableGetter = {(texture: renderable.frameBufferRenderedTexture, location: 0)}
    }
}