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
    
    var mediumShotProgram: MediumShotProgram!
    var closeShotProgram: CloseShotProgram!
    
    var context: EAGLContext? = nil
    
    var scene: Scene! = nil
    
    lazy var frameBuffer: RenderedTexture = RenderedTexture.initialiseReflectionFrameBuffer()
    
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
        
        self.scene = Scene.loadScene("house_on_cliff")
        
        self.mediumShotProgram = MediumShotProgram(camera: self.scene.camera, directionalLight: self.scene.directionalLight)
        self.mediumShotProgram.compile()
        
        self.closeShotProgram = CloseShotProgram(camera: self.scene.camera, directionalLight: self.scene.directionalLight)
        self.closeShotProgram.compile()
        
        glEnable(GLenum(GL_DEPTH_TEST))
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
        frameBuffer.bind()
        renderTexture()
        frameBuffer.unbindCurrentFrameBuffer()
        renderScene()
        
    }
    
    func renderTexture() {
        glClearColor(1.0, 0.65, 0.25, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT));
    }
    
    func renderScene() {
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT));
        
        glUseProgram(self.mediumShotProgram.glName)
        self.mediumShotProgram.render(self.scene.mediumShots)
        
        glUseProgram(self.closeShotProgram.glName)
        self.closeShotProgram.render(self.scene.closeShots)
    }
}


func glGenTextureFromFramebuffer(t: UnsafeMutablePointer<GLuint>, f: UnsafeMutablePointer<GLuint>, w: GLsizei, h: GLsizei) {
    glGenFramebuffers(1, f);
    glGenTextures(1, t);
    
    glBindFramebuffer(GLenum(GL_FRAMEBUFFER), f.memory);
    
    glBindTexture(GLenum(GL_TEXTURE_2D), t.memory);
    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST);
    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST);
    glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, w, h, 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), nil);
    glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_TEXTURE_2D), t.memory, 0);
    
    var depthbuffer: GLuint = 0;
    glGenRenderbuffers(1, &depthbuffer);
    glBindRenderbuffer(GLenum(GL_RENDERBUFFER), depthbuffer);
    glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_DEPTH_COMPONENT16), w, h);
    glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_DEPTH_ATTACHMENT), GLenum(GL_RENDERBUFFER), depthbuffer);
    
    let status = glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER));
    if(status != GLenum(GL_FRAMEBUFFER_COMPLETE)) {
        NSLog("Framebuffer status: %x", Int(status));
    }
}
