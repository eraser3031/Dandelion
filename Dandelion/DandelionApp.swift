//
//  DandelionApp.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/23.
//

import SwiftUI

@main
struct DandelionApp: App {
    let coreDataManager = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            BookListView()
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
        }
    }
}
