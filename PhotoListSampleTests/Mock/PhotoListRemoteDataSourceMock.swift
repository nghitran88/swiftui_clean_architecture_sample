//
//  PhotoListRemoteDataSourceMock.swift
//  PhotoListSampleTests
//
//  Created by Nghi Tran on 22/1/25.
//

import Foundation

final class PhotoListRemoteDataSourceMockSuccess: PhotoListRemoteDataSourceProtocol {
    func loadPhotos() async throws -> [Photo] {
        let mockPhotosDTO = try MockDataProvider.shared.loadPhotosFromJSON()
        return mockPhotosDTO.compactMap({ $0.toDomain() })
    }
}

final class PhotoListRemoteDataSourceMockFailure: PhotoListRemoteDataSourceProtocol {
    func loadPhotos() async throws -> [Photo] {
        throw NetworkError.invalidResponse
    }
}
