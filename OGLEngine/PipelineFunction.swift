//
//  PipelineFunction.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

public class AnyGPUFunction {
    var signature: String
    var input: [AnyGPUVariable]
    var scope: GPUScope? = nil
    
    public init(signature: String, input: [AnyGPUVariable], scope: GPUScope? = nil) {
        self.signature = signature
        self.input = input
        self.scope = scope
    }
}

public class GPUFunction<ReturnType: GLSLType>: AnyGPUFunction {
    override init(signature: String, input: [AnyGPUVariable], scope: GPUScope? = nil) {
        super.init(signature: signature, input: input, scope: scope)
    }
}

public class MainGPUFunction: GPUFunction<GLSLVoid> {
    init(scope: GPUScope) {
        super.init(signature: "main", input: [], scope: scope)
    }
}
