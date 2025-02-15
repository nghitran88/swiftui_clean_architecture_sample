//
//  UpdatePhotoDetailUseCase.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 21/1/25.
//

import Foundation

protocol UpdatePhotoDetailUseCaseProtocol {
    func execute(withPhoto photo: Photo) async throws -> Bool
}

final class UpdatePhotoDetailUseCase: UpdatePhotoDetailUseCaseProtocol {
    private let repository: PhotoDetailRepositoryProtocol

    init(repository: PhotoDetailRepositoryProtocol) {
        self.repository = repository
    }

    func execute(withPhoto photo: Photo) async throws -> Bool {
        do {
            return try await repository.updatePhoto(photo)
        } catch {
            throw error
        }
    }
}
