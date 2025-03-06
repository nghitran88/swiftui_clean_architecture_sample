//
//  FetchPhotoUseCase.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

protocol FetchPhotosUseCaseProtocol {
    func execute(pageNumber: Int, pageSize: Int) async throws -> [Photo]
}

final class FetchPhotosUseCase: FetchPhotosUseCaseProtocol {
    private let repository: PhotoListRepository

    init(repository: PhotoListRepository) {
        self.repository = repository
    }

    func execute(pageNumber: Int, pageSize: Int) async throws -> [Photo] {
        return try await repository.fetchPhotos(pageNumber: pageNumber, pageSize: pageSize)
    }
}
