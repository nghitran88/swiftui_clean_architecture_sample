//
//  PhotoListLocalDataSourceMock.swift
//  PhotoListSampleTests
//
//  Created by Nghi Tran on 22/1/25.
//

import Foundation

final class PhotoListLocalDataSourceMockSuccess: PhotoListLocalDataSourceProtocol {
    func savePhotos(_ photos: [Photo]) async throws {
    }
    
    func loadPhotos() async throws -> [Photo] {
        let mockPhotosDTO = try MockDataProvider.shared.loadPhotosFromJSON()
        return mockPhotosDTO.compactMap({ $0.toDomain() })
    }
}

final class PhotoListLocalDataSourceMockFailure: PhotoListLocalDataSourceProtocol {
    func savePhotos(_ photos: [Photo]) async throws {
        let NSPersistentStoreSaveError = 134060
        throw NSError(domain: NSCocoaErrorDomain, code: NSPersistentStoreSaveError, userInfo: nil)
    }
    
    func loadPhotos() async throws -> [Photo] {
        throw PhotoDetailLocalError.photoNotExist
    }
}
