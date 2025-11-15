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
                Color(Color(red: 0.92, green: 0.92, blue: 0.92))
                    .ignoresSafeArea()
                JSBView()
            }
        }
    }
}
