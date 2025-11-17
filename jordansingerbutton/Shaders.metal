#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
};

vertex VertexOut vertex_main(uint vertexID [[vertex_id]]) {
    VertexOut out;
    
    // Full-screen quad vertices
    float2 positions[4] = {
        float2(-1.0, -1.0),
        float2( 1.0, -1.0),
        float2(-1.0,  1.0),
        float2( 1.0,  1.0)
    };
    
    float2 texCoords[4] = {
        float2(0.0, 1.0),
        float2(1.0, 1.0),
        float2(0.0, 0.0),
        float2(1.0, 0.0)
    };
    
    out.position = float4(positions[vertexID], 0.0, 1.0);
    out.texCoord = texCoords[vertexID];
    return out;
}

// Smooth radial color gradient shader
fragment float4 metallic_gradient(VertexOut in [[stage_in]],
                                  constant float &time [[buffer(0)]]) {
    float2 uv = in.texCoord;
    
    // Create a radial gradient from center
    float2 center = float2(0.5, 0.5);
    float dist = distance(uv, center);
    
    // Neumorphic color gradient (subtle light grey tones)
    float3 centerColor = float3(0.925, 0.925, 0.925);  // Light grey (slightly lighter)
    float3 edgeColor = float3(0.915, 0.915, 0.915);     // Light grey (slightly darker)
    
    // Create very subtle smooth gradient
    float gradient = smoothstep(0.0, 0.8, dist);
    float3 color = mix(centerColor, edgeColor, gradient);
    
    return float4(color, 1.0);
}

// Animated color gradient shader with shifting colors
fragment float4 animated_metallic(VertexOut in [[stage_in]],
                                   constant float &time [[buffer(0)]]) {
    float2 uv = in.texCoord;
    
    // Animated neumorphic color palette (very subtle shifts)
    float3 color1 = float3(0.925 + sin(time * 0.3) * 0.008, 
                          0.925 + cos(time * 0.4) * 0.008, 
                          0.925);  // Light grey with subtle warm variation
    float3 color2 = float3(0.920 + sin(time * 0.2) * 0.006, 
                          0.920 + cos(time * 0.3) * 0.006, 
                          0.920);  // Slightly darker grey
    float3 color3 = float3(0.918 + sin(time * 0.25) * 0.005, 
                          0.918 + cos(time * 0.35) * 0.005, 
                          0.918);  // Subtle grey variation
    
    // Create radial gradient
    float2 center = float2(0.5, 0.5);
    float radius = distance(uv, center);
    float angle = atan2(uv.y - 0.5, uv.x - 0.5) + time * 0.3;
    
    // Mix colors based on radius and angle
    float radialMix = smoothstep(0.0, 0.6, radius);
    float angularMix = sin(angle * 2.0) * 0.5 + 0.5;
    
    float3 color = mix(color1, color2, radialMix);
    color = mix(color, color3, angularMix * 0.3);
    
    return float4(color, 1.0);
}

// Multi-color linear gradient
fragment float4 brushed_metal(VertexOut in [[stage_in]],
                              constant float &time [[buffer(0)]]) {
    float2 uv = in.texCoord;
    
    // Neumorphic multi-color gradient (top to bottom)
    float3 topColor = float3(0.928, 0.928, 0.928);     // Light grey (top)
    float3 middleColor = float3(0.922, 0.922, 0.922);  // Medium light grey
    float3 bottomColor = float3(0.918, 0.918, 0.918);  // Slightly darker grey (bottom)
    
    // Create vertical gradient
    float verticalGradient = uv.y;
    
    // Mix colors
    float3 color;
    if (verticalGradient < 0.5) {
        // Top half: mix top and middle
        color = mix(topColor, middleColor, verticalGradient * 2.0);
    } else {
        // Bottom half: mix middle and bottom
        color = mix(middleColor, bottomColor, (verticalGradient - 0.5) * 2.0);
    }
    
    // Add very subtle horizontal variation (neumorphic style)
    float horizontalWave = sin(uv.x * 3.14159) * 0.003;
    color += horizontalWave;
    
    return float4(color, 1.0);
}

