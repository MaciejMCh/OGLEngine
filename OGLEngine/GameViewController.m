//
//  GameViewController.m
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>
//#import "OBJ+samples.h"
//#import "VAO.h"
//#import "Texture.h"
//#import "SpinningGeometryModel.h"
#import "BasicCamera.h"
#import "OBJLoader.h"
//#import "StaticGeometryModel.h"
#import "FocusingCamera.h"
//#import "Renderable.h"
#import "FocusingCamera.h"
#import "RemoteControlledCamera.h"
//#import "DirectionalLight.h"
#import "OGLEngine-Swift.h"

@interface GameViewController () {
    GLuint _program;
}
@property (strong, nonatomic) EAGLContext *context;

@property (nonatomic, strong) id<Camera> camera;
@property (nonatomic, strong) DirectionalLight *directionalLight;
@property (nonatomic, strong) NSMutableArray<Renderable *> *renderables;
@property (nonatomic, strong) Texture *normalMap;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

//enum {
//    uniformTexture,
//    uniformNormalMap,
//    uniformModelMatrix,
//    uniformViewMatrix,
//    uniformProjectionMatrix,
//    uniformNormalMatrix,
//    uniformEyePosition,
//    uniformDirectionalLightDirection,
//    uniformsCount
//};
//GLint uniforms[uniformsCount];

@implementation GameViewController

- (void)setupGL {
    [EAGLContext setCurrentContext:self.context];
    [self loadShaders];
    glUseProgram(_program);
    glEnable(GL_DEPTH_TEST);
    
    self.renderables = [NSMutableArray new];
    
    // Vaos
    VAO *cubeVao = [[VAO alloc] initWithOBJ:[OBJLoader objFromFileNamed:@"cube"]];
    VAO *torusVao = [[VAO alloc] initWithOBJ:[OBJLoader objFromFileNamed:@"paczek"]];
    VAO *cubeTexVao = [[VAO alloc] initWithOBJ:[OBJLoader objFromFileNamed:@"cube_tex"]];
    VAO *axesVao = [[VAO alloc] initWithOBJ:[OBJLoader objFromFileNamed:@"axes"]];
//    VAO *groundVao = [[VAO alloc] initWithOBJ:[OBJ square]];
    
    // Textures
    Texture *orangeTexture = [[Texture alloc] initWithColor:[UIColor orangeColor]];
    Texture *grayTexture = [[Texture alloc] initWithColor:[UIColor grayColor]];
    Texture *axesTexture = [[Texture alloc] initWithImageNamed:@"axes_rgb"];
    Texture *groundTexture = [[Texture alloc] initWithColor:[UIColor brownColor]];
    
    [orangeTexture bind];
    [grayTexture bind];
    [axesTexture bind];
    [groundTexture bind];
    
    // Geometry models
    SpinningGeometryModel *spinningGeometryModel = [[SpinningGeometryModel alloc] initWithPosition:GLKVector3Make(0, 0, 0)];
    StaticGeometryModel *originGeometryModel = [[StaticGeometryModel alloc] initWithPosition:GLKVector3Make(0, 0, 0)];
    GLKMatrix4 mat = [originGeometryModel modelMatrix];
//    [originGeometryModel wtf:GLKMatrix4Identity];
    StaticGeometryModel *xGeometryModel = [[StaticGeometryModel alloc] initWithPosition:GLKVector3Make(1, 0, 0)];
    StaticGeometryModel *yGeometryModel = [[StaticGeometryModel alloc] initWithPosition:GLKVector3Make(0, 1, 0)];
    StaticGeometryModel *zGeometryModel = [[StaticGeometryModel alloc] initWithPosition:GLKVector3Make(0, 0, 1)];
    
    StaticGeometryModel *standingGeometryModel = [[StaticGeometryModel alloc] initWithPosition:GLKVector3Make(5, 0, 0)];
//    StaticGeometryModel *groundGeometryModel = [[StaticGeometryModel alloc] initWithModelMatrix:GLKMatrix4MakeScale(100, 100, 0.01)];
    
    
    // Renderables
    [self.renderables addObject:[[Renderable alloc] initWithVao:torusVao geometryModel:standingGeometryModel texture:orangeTexture]];
    [self.renderables addObject:[[Renderable alloc] initWithVao:axesVao geometryModel:originGeometryModel texture:axesTexture]];
//    [self.renderables addObject:[[Renderable alloc] initWithVao:axesVao geometryModel:xGeometryModel texture:axesTexture]];
//    [self.renderables addObject:[[Renderable alloc] initWithVao:axesVao geometryModel:yGeometryModel texture:axesTexture]];
//    [self.renderables addObject:[[Renderable alloc] initWithVao:axesVao geometryModel:zGeometryModel texture:axesTexture]];
//    [self.renderables addObject:[[Renderable alloc] initWithVao:groundVao geometryModel:originGeometryModel texture:groundTexture]];
    [self.renderables addObject:[[Renderable alloc] initWithVao:cubeTexVao geometryModel:originGeometryModel texture:orangeTexture]];
    
    int gridRadius = 5;
    for (int i=-gridRadius; i<gridRadius; i++) {
            GLKMatrix4 model = GLKMatrix4MakeScale(.01, 10, .01);
            model = GLKMatrix4Translate(model, i * 100, 0, 0);
//        StaticGeometryModel *geometry = [[StaticGeometryModel alloc] initWithPosition:GLKVector3Make(i * 100, 0, 0) scale:GLKVector3Make(.01, 10, .01)];
//            [self.renderables addObject:[[Renderable alloc] initWithVao:cubeVao geometryModel:geometry texture:grayTexture]];
    }
    for (int i=-gridRadius; i<gridRadius; i++) {
        GLKMatrix4 model = GLKMatrix4MakeScale(10, .01, .01);
        model = GLKMatrix4Translate(model, 0, i * 100, 0);
//        StaticGeometryModel *geometry = [[StaticGeometryModel alloc] initWithModelMatrix:model];
//        [self.renderables addObject:[[Renderable alloc] initWithVao:cubeVao geometryModel:geometry texture:grayTexture]];
    }
    
    // Light
    self.directionalLight = [[DirectionalLight alloc] initWithLightDirection:GLKVector3Make(0, -1, -1)];
    
    // Normal map
    self.normalMap = [[Texture alloc] initWithImageNamed:@"normalMap"];
    [self.normalMap bind];
    
    // Camera
    RemoteControlledCamera *camera = [RemoteControlledCamera new];
    camera.yOffset = -2;
    camera.zOffset = -1;
    camera.xMouse = M_PI_2;
    camera.yMouse = M_PI_4;
    self.camera = camera;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update {
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    // Pass lighting data
    GLKVector3 eyePosition = [self.camera cameraPosition];
    float vectorArray[3] = {-eyePosition.x, -eyePosition.y, -eyePosition.z};
    glUniform3fv([Program ProgramUniformEyePosition], 1, vectorArray);
    
    GLKVector3 directionalLightDirection = self.directionalLight.direction;
    float vectorArray2[3] = {directionalLightDirection.x, directionalLightDirection.y, directionalLightDirection.z};
    glUniform3fv([Program ProgramUniformDirectionalLightDirection], 1, vectorArray2);
    
    [Renderer render:self.renderables camera:self.camera normalMap:self.normalMap];
    
//    for (Renderable *renderable in self.renderables) {
//        [Renderer bind:renderable];
//        [Renderer bindTexture:renderable normalMap:self.normalMap];
//        [Renderer passMatrices:renderable camera:self.camera];
//        [Renderer draw:renderable];
//        [Renderer unbind:renderable];
//    }
    
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders {
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, VboIndexPositions, "aPosition");
    glBindAttribLocation(_program, VboIndexTexels, "aTexel");
    glBindAttribLocation(_program, VboIndexNormals, "aNormal");
    glBindAttribLocation(_program, VboIndexTangents, "aTangent");
    glBindAttribLocation(_program, VboIndexBitangents, "aBitangent");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    [Program setProgramUniformTexture:glGetUniformLocation(_program, "uTexture")];
    [Program setProgramUniformNormalMap:glGetUniformLocation(_program, "uNormalMap")];
    
    [Program setProgramUniformModelMatrix:glGetUniformLocation(_program, "uModelMatrix")];
    [Program setProgramUniformViewMatrix:glGetUniformLocation(_program, "uViewMatrix")];
    [Program setProgramUniformProjectionMatrix:glGetUniformLocation(_program, "uProjectionMatrix")];
    
    [Program setProgramUniformNormalMatrix:glGetUniformLocation(_program, "uNormalMatrix")];
    [Program setProgramUniformEyePosition:glGetUniformLocation(_program, "uEyePosition")];
    [Program setProgramUniformDirectionalLightDirection:glGetUniformLocation(_program, "uDirectionalLightDirection")];
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
}

- (void)dealloc {
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    
    // Dispose of any resources that can be recreated.
}

- (void)tearDownGL {
    [EAGLContext setCurrentContext:self.context];
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
