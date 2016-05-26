//
//  AppDelegate.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 28.03.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        NSLog(GLSLParser.vertexShader(DefaultPipelines.mediumShotPipeline().vertexShader))
        
//        NSLog(GLSLParser.scope(DefaultScopes.MediumShotVertexScope(
//            TypedGPUVariable<GLSLVec4>(name: "gl_Position"),
//            aPosition: TypedGPUVariable<GLSLVec4>(name: "aPosition"),
//            aTexel: TypedGPUVariable<GLSLVec2>(name: "aTexel"),
//            aNormal: TypedGPUVariable<GLSLVec3>(name: "aNormal"),
//            vTexel: TypedGPUVariable<GLSLVec2>(name: "vTexel"),
//            vLighDirection: TypedGPUVariable<GLSLVec3>(name: "vLighDirection"),
//            vLighHalfVector: TypedGPUVariable<GLSLVec3>(name: "vLighHalfVector"),
//            vNormal: TypedGPUVariable<GLSLVec3>(name: "vNormal"),
//            uLighDirection: TypedGPUVariable<GLSLVec3>(name: "uLighDirection"),
//            uLighHalfVector: TypedGPUVariable<GLSLVec3>(name: "uLighHalfVector"),
//            uNormalMatrix: TypedGPUVariable<GLSLMat3>(name: "uNormalMatrix"),
//            uModelViewProjectionMatrix: TypedGPUVariable<GLSLMat4>(name: "uModelViewProjectionMatrix"))))
        
//        NSLog("\n" + GLSLParser.scope(DefaultScopes.PhongReflectionColorScope()))
        
//        NSLog("\n" + GLSLParser.scope(DefaultScopes.AttributesDeclaration.ViewSpaceCalculation().scope))
        
//        NSLog("\n" + GLSLParser.scope(DefaultScopes.VertexShaders.MediumShot()))
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

