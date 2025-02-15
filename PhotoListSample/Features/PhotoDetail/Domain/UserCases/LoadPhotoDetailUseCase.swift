//
//  LoadPhotoDetail.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

protocol LoadPhotoDetailUseCaseProtocol {
    func execute(withID id: Int64) async throws -> Photo?
}

final class LoadPhotoDetailUseCase: LoadPhotoDetailUseCaseProtocol {
    private let repository: PhotoDetailRepositoryProtocol

    init(repository: PhotoDetailRepositoryProtocol) {
        self.repository = repository
    }

    func execute(withID id: Int64) async throws -> Photo? {
        do {
            return try await repository.loadPhoto(id: id)
        } catch {
            throw error
        }
    }
}
