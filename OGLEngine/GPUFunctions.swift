//
//  GPUFunctions.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 11.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

struct DefaultGPUFunction {
    static func rayBoxTexelWithNormal() -> GPUFunction<GLSLVec2> {
        let scope = GPUScope()
        let normal = GPUVariable<GLSLVec3>(name: "normal")
        
        scope ✍ FixedGPUInstruction(
            code: stringFromLines([
                "lowp float a,b,c;",
                "a = abs(normal.x);",
                "b = abs(normal.y);",
                "c = abs(normal.z);",
                "int wallIndex = 0;",
                
                "if (a>b) {",
                "   if (a>c) {",//a
                "       if (normal.x > 0.0) {",//+x
                "           wallIndex = 2;",
                "       } else {",//-x
                "           wallIndex = 0;",
                "       }",
                "   } else {",//c
                "       if (normal.z > 0.0) {",//+z
                "           wallIndex = 4;",
                "       } else {",//-z
                "           wallIndex = 5;",
                "       }",
                "   }",
                "} else {",
                "   if (b>c) {",//b
                "       if (normal.y > 0.0) {",//+y
                "           wallIndex = 1;",
                "       } else {",//-y
                "           wallIndex = 3;",
                "       }",
                "   } else {",//c
                "       if (normal.z > 0.0) {",//+z
                "           wallIndex = 4;",
                "       } else {",//-z
                "           wallIndex = 5;",
                "       }",
                "   }",
                "}",
                
                "lowp vec2 result[6];",
                "result[0] = vec2(0.4999, 0.8);",
                "result[1] = vec2(0.5001, 0.8);",
                "result[2] = vec2(0.4999, 0.5);",
                "result[3] = vec2(0.5001, 0.5);",
                "result[4] = vec2(0.4999, 0.1);",
                "result[5] = vec2(0.5001, 0.1);",
                
                "return result[wallIndex];"
                
//                "if (wallIndex == 0) {",
//                "   return vec2(0.4999, 0.8);",
//                "} else {",
//                "   if (wallIndex == 1) {",
//                "       return vec2(0.5001, 0.8);",
//                "   } else {",
//                "       if (wallIndex == 2) {",
//                "           return vec2(0.4999, 0.5);",
//                "       } else {",
//                "           if (wallIndex == 3) {",
//                "               return vec2(0.5001, 0.5);",
//                "           }",
//                "       }",
//                "   }",
//                "}",
//                "return vec2(0.0, 0.0);"
                ]))
        
        return GPUFunction<GLSLVec2>(signature: "rayBoxTexelWithNormal", input: [normal], scope: scope)
    }
}