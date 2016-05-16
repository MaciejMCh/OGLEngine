//
//  Renderer.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 16.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

struct Renderer {
    static var closeShotProgram: CloseShotProgram!
    static var mediumShotProgram: MediumShotProgram!
    static var reflectiveSurfaceProgram: ReflectiveSurfaceProgram!
    
    static func render(scene: Scene) {
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT));
        
        glUseProgram(self.mediumShotProgram.glName)
        self.mediumShotProgram.render(scene.mediumShots)
        
        glUseProgram(self.closeShotProgram.glName)
        self.closeShotProgram.render(scene.closeShots)
        
        glUseProgram(self.reflectiveSurfaceProgram.glName)
        self.reflectiveSurfaceProgram.render(scene.reflectiveSurfaces)
    }
    
    static func renderNonReflective(scene: Scene) {
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT));
        
        glUseProgram(self.mediumShotProgram.glName)
        self.mediumShotProgram.render(scene.mediumShots)

        glUseProgram(self.closeShotProgram.glName)
        self.closeShotProgram.render(scene.closeShots)
    }
    
}