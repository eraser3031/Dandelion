//
//  DandelionApp.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/23.
//

import SwiftUI

@main
struct DandelionApp: App {
    
    @State private var isLaunch = true
    
    let coreDataManager = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                BookListView()
                    .environment(\.managedObjectContext, coreDataManager.container.viewContext)
                
                ZStack {
                    if isLaunch {
                        LaunchScreenView()
                            .transition(.opacity)
                    }
                }
            }
            .task {
                Task {
                    try await Task.sleep(nanoseconds: 400_000_000)
                    withAnimation {
                        isLaunch = false
                    }
                }
            }
        }
    }
}
