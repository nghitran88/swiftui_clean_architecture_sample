//
//  PhotoDetailRepository.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

protocol PhotoDetailRepositoryProtocol {
    func loadPhoto(id: Int64) async throws -> Photo?
    func updatePhoto(_ photo: Photo) async throws -> Bool
}

final class PhotoDetailRepository: PhotoDetailRepositoryProtocol {
    private let localDataSource: PhotoDetailLocalDataSourceProtocol

    init(localDataSource: PhotoDetailLocalDataSourceProtocol) {
        self.localDataSource = localDataSource
    }
    
    func loadPhoto(id: Int64) async throws -> Photo? {
        do {
            let photo = try await localDataSource.loadPhoto(id: id)
            return photo
        } catch {
            throw error
        }
    }
    
    func updatePhoto(_ photo: Photo) async throws -> Bool {
        guard photo.id > 0 else {
            return false
        }
        
        do {
            return try await localDataSource.updatePhoto(photo)
        } catch {
            throw error
        }
    }
}
