//
//  PipelineFunction.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

public class AnyGPUFunction: AnyFunction {
    var signature: String
    var input: [AnyVariable]
    var scope: GPUScope? = nil
    
    var arguments: [AnyVariable] {
        return input
    }
    
    public init(signature: String, input: [AnyVariable], scope: GPUScope? = nil) {
        self.signature = signature
        self.input = input
        self.scope = scope
    }
}

public class GPUFunction<ReturnType: GLSLType>: AnyGPUFunction {
    override init(signature: String, input: [AnyVariable], scope: GPUScope? = nil) {
        super.init(signature: signature, input: input, scope: scope)
    }
}

public class MainGPUFunction: GPUFunction<GLSLVoid> {
    init(scope: GPUScope) {
        super.init(signature: "main", input: [], scope: scope)
    }
}
