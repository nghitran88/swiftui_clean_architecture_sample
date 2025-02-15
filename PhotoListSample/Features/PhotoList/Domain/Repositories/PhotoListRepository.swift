//
//  PhotoListRepository.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

protocol PhotoListRepositoryProtocol {
    func fetchPhotos() async throws -> [Photo]
}

final class PhotoListRepository: PhotoListRepositoryProtocol {
    private let localDataSource: PhotoListLocalDataSourceProtocol
    private let remoteDataSource: PhotoListRemoteDataSourceProtocol

    init(localDataSource: PhotoListLocalDataSourceProtocol, remoteDataSource: PhotoListRemoteDataSourceProtocol) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchPhotos() async throws -> [Photo] {
        do {
            //Load cache data first
            var photos = try await localDataSource.loadPhotos()
            if photos.count > 0 {
                return photos
            }
            
            //Fetch remote data
            photos = try await remoteDataSource.loadPhotos()
            
            //Save the photos to local database
            try await localDataSource.savePhotos(photos)
            
            return photos
        } catch {
            throw error
        }
    }
}
