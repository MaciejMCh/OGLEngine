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
    
    var mediumShotProgram: MediumShotPipelineProgram!
    var closeShotProgram: CloseShotPipelineProgram!
    var reflectiveSurfaceProgram: ReflectiveSurfacePipelineProgram!
    var reflectedProgram: ReflectedPipelineProgram!
    
    var context: EAGLContext? = nil
    
    var scene: Scene! = nil
    
    lazy var renderedTexture: RenderedTexture = RenderedTexture()
    
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
        
        let program = ReflectiveSurfacePipelineProgram()
        NSLog("\n" + GLSLParser.vertexShader(program.pipeline.vertexShader))
        NSLog("\n\n\n\n" + GLSLParser.fragmentShader(program.pipeline.fragmentShader))
        
        self.scene = Scene.loadScene("house_on_cliff")
        
        self.mediumShotProgram = MediumShotPipelineProgram()
        self.mediumShotProgram.compile()
        
        self.closeShotProgram = CloseShotPipelineProgram()
        self.closeShotProgram.compile()
        
        self.reflectiveSurfaceProgram = ReflectiveSurfacePipelineProgram()
        self.reflectiveSurfaceProgram.compile()
        
        self.reflectedProgram = ReflectedPipelineProgram()
        self.reflectedProgram.compile()
        
        glEnable(GLenum(GL_DEPTH_TEST))
        
        Renderer.closeShotProgram = closeShotProgram
        Renderer.mediumShotProgram = mediumShotProgram
        Renderer.reflectiveSurfaceProgram = reflectiveSurfaceProgram
        Renderer.reflectedProgram = reflectedProgram
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
        Renderer.render(scene)
    }
    
    func renderTexture() {
        glClearColor(1.0, 0.65, 0.25, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT));
    }
}
