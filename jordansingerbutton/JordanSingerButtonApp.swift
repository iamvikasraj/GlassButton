//
//  JordanSingerButtonApp.swift
//  jordansingerbutton
//
//  Created by Vikas Raj Yadav on 02/07/25.
//

import SwiftUI

@main
struct JSBApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                MetalBackground(shaderType: .metallicGradient)
                JSBView()
            }
        }
    }
}
