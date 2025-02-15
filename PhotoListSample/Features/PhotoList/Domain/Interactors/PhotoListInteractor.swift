//
//  PhotoListInteractor.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

protocol PhotoListInteractorProtocol {
    func fetchPhotos() async throws -> [Photo]
    func loadPhotoDetail(withID id: Int64) async throws -> Photo?
}

final class PhotoListInteractor: PhotoListInteractorProtocol {
    let fetchPhotosUseCase: FetchPhotosUseCaseProtocol
    let loadPhotoDetailUseCase: LoadPhotoDetailUseCaseProtocol
    
    init(fetchPhotosUseCase: FetchPhotosUseCaseProtocol, loadPhotoDetailUseCase: LoadPhotoDetailUseCaseProtocol) {
        self.fetchPhotosUseCase = fetchPhotosUseCase
        self.loadPhotoDetailUseCase = loadPhotoDetailUseCase
    }

    func fetchPhotos() async throws -> [Photo] {
        do {
            return try await fetchPhotosUseCase.execute()
        } catch {
            throw error
        }
    }
    
    func loadPhotoDetail(withID id: Int64) async throws -> Photo? {
        do {
            return try await loadPhotoDetailUseCase.execute(withID: id)
        } catch {
            throw error
        }
    }
}
