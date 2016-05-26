//
//  Program.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 28.03.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

protocol GPUProgram {
    associatedtype RenderableType
    var shaderSource: GLSLShaderCodeSource {get}
    var interface: GPUInterface {get}
    var implementation: GPUImplementation {get set}
    var glName: GLuint { get set }
    
    mutating func compile()
    func render(renderables: [RenderableType])
    func programDidCompile()
}

extension GPUProgram {
    
    mutating func compile() {
        self.loadShaders()
        self.validate()
        self.programDidCompile()
    }
    
    func programDidCompile() {
        
    }
    
    func validate() {
        for instance in self.implementation.instances {
            assert(instance.location != -1, instance.uniform.gpuDomainName() + " binding failed")
        }
    }
    
    mutating func loadShaders() -> Bool {
        var vertShader: GLuint = 0
        var fragShader: GLuint = 0
        
        // Create shader program.
        self.glName = glCreateProgram()
        
        // Create and compile vertex shader.
        let vertShaderCode = self.shaderSource.vertexShaderCode()
        if self.compileShader(&vertShader, type: GLenum(GL_VERTEX_SHADER), code: vertShaderCode) == false {
            print("Failed to compile vertex shader")
            assert(false)
            return false
        }
        
        // Create and compile fragment shader.
        let fragShaderCode = self.shaderSource.fragmentShaderCode()
        if !self.compileShader(&fragShader, type: GLenum(GL_FRAGMENT_SHADER), code: fragShaderCode) {
            print("Failed to compile fragment shader")
            assert(false)
            return false
        }
        
        // Attach vertex shader to program.
        glAttachShader(glName, vertShader)
        
        // Attach fragment shader to program.
        glAttachShader(glName, fragShader)
        
        // Bind attribute locations.
        // This needs to be done prior to linking.
        
        for attribute in self.interface.attributes {
            glBindAttribLocation(self.glName, attribute.location(), attribute.gpuDomainName())
        }
        
        // Link program.
        if !self.linkProgram(glName) {
            print("Failed to link program: \(glName)")
            
            if vertShader != 0 {
                glDeleteShader(vertShader)
                vertShader = 0
            }
            if fragShader != 0 {
                glDeleteShader(fragShader)
                fragShader = 0
            }
            if self.glName != 0 {
                glDeleteProgram(glName)
                self.glName = 0
            }
            
            return false
        }
        
        // Get uniform locations.
        self.implementation = GPUImplementation(instances: self.interface.uniforms.map{
            let location = glGetUniformLocation(self.glName, $0.gpuDomainName())
            return GPUInstance(uniform: $0, location: location)
            })
        
        // Release vertex and fragment shaders.
        if vertShader != 0 {
            glDetachShader(glName, vertShader)
            glDeleteShader(vertShader)
        }
        if fragShader != 0 {
            glDetachShader(glName, fragShader)
            glDeleteShader(fragShader)
        }
        
        return true
    }
    
    
    func compileShader(inout shader: GLuint, type: GLenum, code: String) -> Bool {
        var status: GLint = 0
        let source: UnsafePointer<Int8> = (code as NSString).UTF8String
//        do {
//            source = try NSString(contentsOfFile: code, encoding: NSUTF8StringEncoding).UTF8String
//        } catch {
//            print("Failed to load vertex shader")
//            return false
//        }
        var castSource = UnsafePointer<GLchar>(source)
        
        shader = glCreateShader(type)
        glShaderSource(shader, 1, &castSource, nil)
        glCompileShader(shader)
        
//        #if defined(DEBUG)
                var logLength: GLint = 0
                glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
                if logLength > 0 {
                    let log = UnsafeMutablePointer<GLchar>(malloc(Int(logLength)))
                    glGetShaderInfoLog(shader, logLength, &logLength, log)
                    NSLog("Shader compile log: \n%s", log)
                    free(log)
                }
//        #endif
        
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
        if status == 0 {
            glDeleteShader(shader)
            return false
        }
        return true
    }
    
    func linkProgram(prog: GLuint) -> Bool {
        var status: GLint = 0
        glLinkProgram(prog)
        
        //#if defined(DEBUG)
//                var logLength: GLint = 0
//                glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
//                if logLength > 0 {
//                    var log = UnsafeMutablePointer<GLchar>(malloc(Int(logLength)))
//                    glGetShaderInfoLog(shader, logLength, &logLength, log)
//                    NSLog("Shader compile log: \n%s", log)
//                    free(log)
//                }
        //#endif
        
        glGetProgramiv(prog, GLenum(GL_LINK_STATUS), &status)
        if status == 0 {
            return false
        }
        
        return true
    }
    
    func validateProgram(prog: GLuint) -> Bool {
        var logLength: GLsizei = 0
        var status: GLint = 0
        
        glValidateProgram(prog)
        glGetProgramiv(prog, GLenum(GL_INFO_LOG_LENGTH), &logLength)
        if logLength > 0 {
            var log: [GLchar] = [GLchar](count: Int(logLength), repeatedValue: 0)
            glGetProgramInfoLog(prog, logLength, &logLength, &log)
            print("Program validate log: \n\(log)")
        }
        
        glGetProgramiv(prog, GLenum(GL_VALIDATE_STATUS), &status)
        var returnVal = true
        if status == 0 {
            returnVal = false
        }
        return returnVal
    }
}
