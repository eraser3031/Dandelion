//
//  NetworkingManager.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/28.
//

import Foundation

class NetworkingManager {
    private init() { }
    static let shared = NetworkingManager()
    func request(url: URL) async -> Data? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return nil
            }
            return data
        } catch {
            print(error)
        }
        return nil
    }
}
