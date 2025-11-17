//
//  MetalBackgroundView.swift
//  jordansingerbutton
//
//  Created for Metal shader background
//

import SwiftUI
import MetalKit
#if os(iOS) || os(tvOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

#if os(iOS) || os(tvOS) || os(visionOS)
struct MetalBackgroundView: UIViewRepresentable {
    var shaderType: MetalShaderType = .metallicGradient
    @State private var time: Float = 0
    
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = false
        mtkView.isPaused = false
        mtkView.framebufferOnly = false
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        if context.coordinator.shaderType != shaderType {
            context.coordinator.shaderType = shaderType
            context.coordinator.setupMetal()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(shaderType: shaderType)
    }
}
#elseif os(macOS)
    struct MetalBackgroundView: NSViewRepresentable {
        var shaderType: MetalShaderType = .metallicGradient
        @State private var time: Float = 0
        
        func makeNSView(context: Context) -> MTKView {
            let mtkView = MTKView()
            mtkView.device = MTLCreateSystemDefaultDevice()
            mtkView.delegate = context.coordinator
            mtkView.preferredFramesPerSecond = 60
            mtkView.enableSetNeedsDisplay = false
            mtkView.isPaused = false
            mtkView.framebufferOnly = false
            return mtkView
        }
        
        func updateNSView(_ nsView: MTKView, context: Context) {
            if context.coordinator.shaderType != shaderType {
                context.coordinator.shaderType = shaderType
                context.coordinator.setupMetal()
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(shaderType: shaderType)
        }
    }
#endif
    
    class Coordinator: NSObject, MTKViewDelegate {
        var shaderType: MetalShaderType
        var device: MTLDevice!
        var commandQueue: MTLCommandQueue!
        var pipelineState: MTLRenderPipelineState!
        var time: Float = 0
        
        init(shaderType: MetalShaderType) {
            self.shaderType = shaderType
            super.init()
            setupMetal()
        }
        
        func setupMetal() {
            device = MTLCreateSystemDefaultDevice()
            guard let device = device else { return }
            
            commandQueue = device.makeCommandQueue()
            
            // Load shader library
            guard let library = device.makeDefaultLibrary() else { return }
            
            // Create pipeline state
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertex_main")
            
            // Set fragment function based on shader type
            switch shaderType {
            case .metallicGradient:
                pipelineDescriptor.fragmentFunction = library.makeFunction(name: "metallic_gradient")
            case .animatedMetallic:
                pipelineDescriptor.fragmentFunction = library.makeFunction(name: "animated_metallic")
            case .brushedMetal:
                pipelineDescriptor.fragmentFunction = library.makeFunction(name: "brushed_metal")
            }
            
            pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            
            do {
                pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
            } catch {
                print("Failed to create pipeline state: \(error)")
            }
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            // Handle size changes if needed
        }
        
        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let renderPassDescriptor = view.currentRenderPassDescriptor,
                  let pipelineState = pipelineState,
                  let commandBuffer = commandQueue.makeCommandBuffer() else {
                return
            }
            
            // Update time
            time += 0.016 // ~60fps
            
            guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
                return
            }
            
            renderEncoder.setRenderPipelineState(pipelineState)
            renderEncoder.setFragmentBytes(&time, length: MemoryLayout<Float>.size, index: 0)
            renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
            renderEncoder.endEncoding()
            
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }

enum MetalShaderType {
    case metallicGradient
    case animatedMetallic
    case brushedMetal
}

// SwiftUI wrapper for easier use
struct MetalBackground: View {
    var shaderType: MetalShaderType = .metallicGradient
    
    var body: some View {
        MetalBackgroundView(shaderType: shaderType)
            .ignoresSafeArea()
    }
}

#Preview {
    MetalBackground(shaderType: .animatedMetallic)
}
