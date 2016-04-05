//
//  GameViewController.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 27.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import GLKit
import OpenGLES

class GameViewController: GLKViewController {
    
    var program: GPUProgram!
    var context: EAGLContext? = nil
    
    var scene: Scene! = nil
    
    deinit {
        self.tearDownGL()
    
        if EAGLContext.currentContext() === self.context {
            EAGLContext.setCurrentContext(nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.context = EAGLContext(API: .OpenGLES2)
        
        if !(self.context != nil) {
            print("Failed to create ES context")
        }
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .Format24
        
        self.setupGL()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        if self.isViewLoaded() && (self.view.window != nil) {
            self.view = nil
            
            self.tearDownGL()
            
            if EAGLContext.currentContext() === self.context {
                EAGLContext.setCurrentContext(nil)
            }
            self.context = nil
        }
    }
    
    func setupGL() {
        EAGLContext.setCurrentContext(self.context)
        
        var program = CloseShotProgram()
        program.loadShaders()
        
        self.program = program
        
        glUseProgram(program.glName)
        
        glEnable(GLenum(GL_DEPTH_TEST))
        
        self.scene = Scene()
        
        program.camera = self.scene.camera
        program.directionalLight = self.scene.directionalLight
        program.normalMap = self.scene.normalMap
        
    }
    
    func tearDownGL() {
//        EAGLContext.setCurrentContext(self.context)
//        
//        glDeleteBuffers(1, &vertexBuffer)
//        glDeleteVertexArraysOES(1, &vertexArray)
//        
//        self.effect = nil
//        
//        if program != 0 {
//            glDeleteProgram(program)
//            program = 0
//        }
    }
    
    // MARK: - GLKView and GLKViewController delegate methods
    
    func update() {
        
    }
    
    override func glkView(view: GLKView, drawInRect rect: CGRect) {
        
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT));
        
        self.program.render(self.scene.renderables)

        
//        Renderer.prepareBuffer()
//        Renderer.passData(self.scene.camera, light: self.scene.directionalLight)
//        Renderer.render(self.scene.renderables, camera: self.scene.camera, normalMap: self.scene.normalMap)
        
    }
    
    // MARK: -  OpenGL ES 2 shader compilation
    
//    func loadShaders() -> Bool {
//        var vertShader: GLuint = 0
//        var fragShader: GLuint = 0
//        var vertShaderPathname: String
//        var fragShaderPathname: String
//        
//        // Create shader program.
//        program = glCreateProgram()
//        
//        // Create and compile vertex shader.
//        vertShaderPathname = NSBundle.mainBundle().pathForResource("Shader", ofType: "vsh")!
//        if self.compileShader(&vertShader, type: GLenum(GL_VERTEX_SHADER), file: vertShaderPathname) == false {
//            print("Failed to compile vertex shader")
//            return false
//        }
//        
//        // Create and compile fragment shader.
//        fragShaderPathname = NSBundle.mainBundle().pathForResource("Shader", ofType: "fsh")!
//        if !self.compileShader(&fragShader, type: GLenum(GL_FRAGMENT_SHADER), file: fragShaderPathname) {
//            print("Failed to compile fragment shader")
//            return false
//        }
//        
//        // Attach vertex shader to program.
//        glAttachShader(program, vertShader)
//        
//        // Attach fragment shader to program.
//        glAttachShader(program, fragShader)
//        
//        // Bind attribute locations.
//        // This needs to be done prior to linking.
//        
//        glBindAttribLocation(program, GLuint(VboIndex.Positions.rawValue), "aPosition")
//        glBindAttribLocation(program, GLuint(VboIndex.Texels.rawValue), "aTexel")
//        glBindAttribLocation(program, GLuint(VboIndex.Normals.rawValue), "aNormal")
//        glBindAttribLocation(program, GLuint(VboIndex.Tangents.rawValue), "aTangent")
//        glBindAttribLocation(program, GLuint(VboIndex.Bitangents.rawValue), "aBitangent")
//        
//        
//        // Link program.
//        if !self.linkProgram(program) {
//            print("Failed to link program: \(program)")
//            
//            if vertShader != 0 {
//                glDeleteShader(vertShader)
//                vertShader = 0
//            }
//            if fragShader != 0 {
//                glDeleteShader(fragShader)
//                fragShader = 0
//            }
//            if program != 0 {
//                glDeleteProgram(program)
//                program = 0
//            }
//            
//            return false
//        }
//        
//        // Get uniform locations.
//        Program.ProgramUniformTexture = glGetUniformLocation(program, "uTexture")
//        Program.ProgramUniformNormalMap = glGetUniformLocation(program, "uNormalMap")
//        
//        Program.ProgramUniformModelMatrix = glGetUniformLocation(program, "uModelMatrix")
//        Program.ProgramUniformViewMatrix = glGetUniformLocation(program, "uViewMatrix")
//        Program.ProgramUniformProjectionMatrix = glGetUniformLocation(program, "uProjectionMatrix")
//        
//        Program.ProgramUniformNormalMatrix = glGetUniformLocation(program, "uNormalMatrix")
//        Program.ProgramUniformEyePosition = glGetUniformLocation(program, "uEyePosition")
//        Program.ProgramUniformDirectionalLightDirection = glGetUniformLocation(program, "uDirectionalLightDirection")
//        
//        // Release vertex and fragment shaders.
//        if vertShader != 0 {
//            glDetachShader(program, vertShader)
//            glDeleteShader(vertShader)
//        }
//        if fragShader != 0 {
//            glDetachShader(program, fragShader)
//            glDeleteShader(fragShader)
//        }
//        
//        return true
//    }
//    
//    
//    func compileShader(inout shader: GLuint, type: GLenum, file: String) -> Bool {
//        var status: GLint = 0
//        var source: UnsafePointer<Int8>
//        do {
//            source = try NSString(contentsOfFile: file, encoding: NSUTF8StringEncoding).UTF8String
//        } catch {
//            print("Failed to load vertex shader")
//            return false
//        }
//        var castSource = UnsafePointer<GLchar>(source)
//        
//        shader = glCreateShader(type)
//        glShaderSource(shader, 1, &castSource, nil)
//        glCompileShader(shader)
//        
//        //#if defined(DEBUG)
//        //        var logLength: GLint = 0
//        //        glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
//        //        if logLength > 0 {
//        //            var log = UnsafeMutablePointer<GLchar>(malloc(Int(logLength)))
//        //            glGetShaderInfoLog(shader, logLength, &logLength, log)
//        //            NSLog("Shader compile log: \n%s", log)
//        //            free(log)
//        //        }
//        //#endif
//        
//        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
//        if status == 0 {
//            glDeleteShader(shader)
//            return false
//        }
//        return true
//    }
//    
//    func linkProgram(prog: GLuint) -> Bool {
//        var status: GLint = 0
//        glLinkProgram(prog)
//        
//        //#if defined(DEBUG)
//        //        var logLength: GLint = 0
//        //        glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
//        //        if logLength > 0 {
//        //            var log = UnsafeMutablePointer<GLchar>(malloc(Int(logLength)))
//        //            glGetShaderInfoLog(shader, logLength, &logLength, log)
//        //            NSLog("Shader compile log: \n%s", log)
//        //            free(log)
//        //        }
//        //#endif
//        
//        glGetProgramiv(prog, GLenum(GL_LINK_STATUS), &status)
//        if status == 0 {
//            return false
//        }
//        
//        return true
//    }
//    
//    func validateProgram(prog: GLuint) -> Bool {
//        var logLength: GLsizei = 0
//        var status: GLint = 0
//        
//        glValidateProgram(prog)
//        glGetProgramiv(prog, GLenum(GL_INFO_LOG_LENGTH), &logLength)
//        if logLength > 0 {
//            var log: [GLchar] = [GLchar](count: Int(logLength), repeatedValue: 0)
//            glGetProgramInfoLog(prog, logLength, &logLength, &log)
//            print("Program validate log: \n\(log)")
//        }
//        
//        glGetProgramiv(prog, GLenum(GL_VALIDATE_STATUS), &status)
//        var returnVal = true
//        if status == 0 {
//            returnVal = false
//        }
//        return returnVal
//    }
}

