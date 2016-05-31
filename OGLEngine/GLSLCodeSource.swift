//
//  GLSLCodeSource.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 26.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

protocol GLSLShaderCodeSource {
    func vertexShaderCode() -> String
    func fragmentShaderCode() -> String
}

struct GLSLFileShaderCodeSource: GLSLShaderCodeSource {
    let shaderFileName: String
    
    func vertexShaderCode() -> String {
        let file = NSBundle.mainBundle().pathForResource(shaderFileName, ofType: "vsh")!
        do {
            let code = try NSString(contentsOfFile: file, encoding: NSUTF8StringEncoding)
            return code as String
        } catch {
            assert(false)
            return ""
        }
    }
    
    func fragmentShaderCode() -> String {
        let file = NSBundle.mainBundle().pathForResource(shaderFileName, ofType: "fsh")!
        do {
            let code = try NSString(contentsOfFile: file, encoding: NSUTF8StringEncoding)
            return code as String
        } catch {
            assert(false)
            return ""
        }
    }
}

struct GLSLParsedCodeSource: GLSLShaderCodeSource {
    let pipeline: GPUPipeline
    
    func vertexShaderCode() -> String {
        return GLSLParser.vertexShader(self.pipeline.vertexShader)
    }
    
    func fragmentShaderCode() -> String {
        return GLSLParser.fragmentShader(self.pipeline.fragmentShader)
    }
}