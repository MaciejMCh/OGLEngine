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
}
