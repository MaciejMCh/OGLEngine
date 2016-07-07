//
//  SkyBoxPipelineProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 05.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class SkyBoxPipelineProgram: PipelineProgram {
    typealias RenderableType = SkyBoxRenderable
    var glName: GLuint = 0
    var pipeline = DefaultPipelines.SkyBox()
}