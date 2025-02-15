//
//  PhotoDetailLocalDataSourceMock.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 22/1/25.
//

import Foundation

final class PhotoDetailLocalDataSourceMockSuccess: PhotoDetailLocalDataSourceProtocol {
    func updatePhoto(_ photo: Photo) async throws -> Bool {
        return true
    }
    
    func loadPhoto(id: Int64) async throws -> Photo? {
        let mockPhotosDTO = try MockDataProvider.shared.loadPhotosFromJSON()
        let photos = mockPhotosDTO.compactMap({ $0.toDomain() })
        return photos.first(where: {$0.id == id})
    }
}

final class PhotoDetailLocalDataSourceMockFailure: PhotoDetailLocalDataSourceProtocol {
    func updatePhoto(_ photo: Photo) async throws -> Bool {
        return false
    }
    
    func loadPhoto(id: Int64) async throws -> Photo? {
        throw PhotoDetailLocalError.photoNotExist
    }
}

