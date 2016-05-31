//
//  PipelineInterpolation.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

public protocol Interpolation {
    func varyings() -> [GPUVarying]
}