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
        
        self.scene = Scene.loadScene("cliff")
        
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
        
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT));
        
        glUseProgram(self.mediumShotProgram.glName)
        self.mediumShotProgram.render(self.scene.mediumShots)
        
        glUseProgram(self.closeShotProgram.glName)
        self.closeShotProgram.render(self.scene.closeShots)
        
        
    }
}

