//
//  ReflectiveSurfacePipelineProgram.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 16.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class ReflectiveSurfacePipelineProgram: PipelineProgram {
    typealias RenderableType = ReflectiveSurfaceRenderable
    var glName: GLuint = 0
    var pipeline = DefaultPipelines.ReflectiveSurface()
}