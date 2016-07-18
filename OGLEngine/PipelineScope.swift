//
//  PipelineScope.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

public class GPUScope {
    var instructions: [GPUInstruction] = []
    var functions: [AnyGPUFunction] = []
    
    func appendInstruction(instruction: GPUInstruction) {
        self.instructions.append(instruction)
    }
    
    func appendFunction(function: AnyGPUFunction) {
        self.functions.append(function)
    }
    
    func mergeScope(scope: GPUScope) {
        var mergedInstructions: [GPUInstruction] = []
        mergedInstructions.appendContentsOf(self.instructions)
        mergedInstructions.appendContentsOf(scope.instructions)
        self.instructions = mergedInstructions
        self.functions.appendContentsOf(scope.functions)
    }
}
