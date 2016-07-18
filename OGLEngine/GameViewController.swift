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
    var skyBoxProgram: SkyBoxPipelineProgram!
    var frameBufferViewerProgram: FrameBufferViewerPipelineProgram!
    
    var rayBoxMappingTestProgram: RayBoxMappingTestProgram!
    var rayBoxMappingTestRenderable: RayBoxMappingTestRenderable!
    
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
        
        DefaultPipelines.LightingIdeaImplementation()
        
        let program = RayBoxMappingTestProgram()
        NSLog("\n" + GLSLParser.vertexShader(program.pipeline.vertexShader))
        NSLog("\n\n\n\n" + GLSLParser.fragmentShader(program.pipeline.fragmentShader))
        
//        self.scene = Scene.loadScene("house_on_cliff")
//        self.scene = Scene.MaterialsPreviewScene("Icosphere")
        
        var scene = Scene.MaterialsPreviewScene("Icosphere")
        scene.closeShots = []
        self.scene = scene
        
        
        self.mediumShotProgram = MediumShotPipelineProgram()
        self.mediumShotProgram.compile()
        
        self.closeShotProgram = CloseShotPipelineProgram()
        self.closeShotProgram.compile()
        
        self.reflectiveSurfaceProgram = ReflectiveSurfacePipelineProgram()
        self.reflectiveSurfaceProgram.compile()
        
        self.reflectedProgram = ReflectedPipelineProgram()
        self.reflectedProgram.compile()
        
        self.skyBoxProgram = SkyBoxPipelineProgram()
        self.skyBoxProgram.compile()
        
        self.frameBufferViewerProgram = FrameBufferViewerPipelineProgram()
        self.frameBufferViewerProgram.compile()
        
        glEnable(GLenum(GL_DEPTH_TEST))
        
        Renderer.closeShotProgram = closeShotProgram
        Renderer.mediumShotProgram = mediumShotProgram
        Renderer.reflectiveSurfaceProgram = reflectiveSurfaceProgram
        Renderer.reflectedProgram = reflectedProgram
        Renderer.skyBoxProgram = skyBoxProgram
        Renderer.frameBufferViewerProgram = frameBufferViewerProgram
        
        
        let texture = frameBufferViewerProgram.renderable.frameBufferRenderedTexture
        self.rayBoxMappingTestProgram = RayBoxMappingTestProgram()
        self.rayBoxMappingTestProgram.compile()
        self.rayBoxMappingTestRenderable = RayBoxMappingTestRenderable(
            vao: VAO(obj: OBJLoader.objFromFileNamed("3dAssets/meshes/Icosphere")),
            geometryModel: StaticGeometryModel(),
            rayBoxColorMap: texture)
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
        Renderer.renderFrameBufferPreview(self.scene)
        
        glUseProgram(self.rayBoxMappingTestProgram.glName)
        self.rayBoxMappingTestProgram.render([self.rayBoxMappingTestRenderable], scene: self.scene)
    }
    
    func renderTexture() {
        glClearColor(1.0, 0.65, 0.25, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT));
    }
}
