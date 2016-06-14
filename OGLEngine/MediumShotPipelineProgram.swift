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
}
