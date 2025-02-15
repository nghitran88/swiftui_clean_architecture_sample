//
//  MockDataProvider.swift
//  PhotoListSampleTests
//
//  Created by Nghi Tran on 22/1/25.
//

import Foundation

enum UnitTestError: Error {
    case mockDataBroken
}

final class MockDataProvider {
    static let shared = MockDataProvider()
    
    func loadPhotosFromJSON() throws -> [PhotoRemoteDTO] {
        guard let url = Bundle(for: type(of: self)).url(forResource: "photos", withExtension: "json") else {
            throw UnitTestError.mockDataBroken
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([PhotoRemoteDTO].self, from: data)
    }
}
