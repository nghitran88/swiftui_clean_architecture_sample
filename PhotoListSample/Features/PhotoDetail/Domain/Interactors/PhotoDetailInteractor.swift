//
//  PhotoDetailInteractor.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

protocol PhotoDetailInteractorProtocol {
    func loadPhoto(id: Int64) async throws -> Photo?
    func updatePhoto(_ photo: Photo) async throws -> Bool
}

final class PhotoDetailInteractor: PhotoDetailInteractorProtocol {
    let loadPhotoUseCase: LoadPhotoDetailUseCaseProtocol
    let updatePhotoUseCase: UpdatePhotoDetailUseCaseProtocol
    
    init(loadPhotoUseCase: LoadPhotoDetailUseCaseProtocol, updatePhotoUseCase: UpdatePhotoDetailUseCaseProtocol) {
        self.loadPhotoUseCase = loadPhotoUseCase
        self.updatePhotoUseCase = updatePhotoUseCase
    }

    func loadPhoto(id: Int64) async throws -> Photo? {
        do {
            return try await loadPhotoUseCase.execute(withID: id)
        } catch {
            throw error
        }
    }
    func updatePhoto(_ photo: Photo) async throws -> Bool {
        do {
            return try await updatePhotoUseCase.execute(withPhoto: photo)
        } catch {
            throw error
        }
    }
}
