//
//  ArrowDateSelectorApp.swift
//  ArrowDateSelector
//
//  Created by Vikas Raj Yadav on 02/07/25.
//

import SwiftUI

@main
struct ArrowDateSelectorApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color(red: 67/255, green: 80/255, blue: 89/255)
                    .ignoresSafeArea()
                
                ArrowButton()
            }
        }
    }
}
