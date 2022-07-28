//
//  Persistence.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/28.
//

import Foundation
import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()

//    static var preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
//        for _ in 0..<10 {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//        }
//        do {
//            try viewContext.save()
//        } catch {
//                        // 이 부분을 적절한 에러처리 코드로 채워주세요.
//            // fatalError()는 어플리케이션을 중지시킵니다. 개발과정외에는 사용하지 말아주세요.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        return result
//    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Dandelion")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // 이 부분을 적절한 에러처리 코드로 채워주세요.
                // fatalError()는 어플리케이션을 중지시킵니다. 개발과정외에는 사용하지 말아주세요.

                /*
                                이곳에서 일어날 수 있는 주요 에러입니다.
                 * 부모 디렉토리가 없거나 접근할 수 없을 때
                 * 디바이스가 잠기는 등 persistent container에 접근할 수 있는 권한이 없을 때
                 * 디바이스의 저장공간이 부족할 때
                 * The store could not be migrated to the current model version.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
