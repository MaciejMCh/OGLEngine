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
    var arguments: [AnyEvaluation]
    var scope: GPUScope? = nil
    
    public init(signature: String, arguments: [AnyEvaluation], scope: GPUScope? = nil) {
        self.signature = signature
        self.arguments = arguments
        self.scope = scope
    }
}

public class GPUFunction<ReturnType: GLSLType>: AnyGPUFunction {
    override init(signature: String, arguments: [AnyEvaluation], scope: GPUScope? = nil) {
        super.init(signature: signature, arguments: arguments, scope: scope)
    }
}

public class MainGPUFunction: GPUFunction<GLSLVoid> {
    init(scope: GPUScope) {
        super.init(signature: "main", arguments: [], scope: scope)
    }
}
