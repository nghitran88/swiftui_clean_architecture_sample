//
//  PhotoListRepository.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

protocol PhotoListRepositoryProtocol {
    func fetchPhotos(pageNumber: Int, pageSize: Int) async throws -> [Photo]
}

final class PhotoListRepository: PhotoListRepositoryProtocol {
    private let localDataSource: PhotoListLocalDataSourceProtocol
    private let remoteDataSource: PhotoListRemoteDataSourceProtocol

    init(localDataSource: PhotoListLocalDataSourceProtocol, remoteDataSource: PhotoListRemoteDataSourceProtocol) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchPhotos(pageNumber: Int, pageSize: Int) async throws -> [Photo] {
        do {
            //Load cache data first
            var photos = try await localDataSource.loadPhotos(pageNumber: pageNumber, pageSize: pageSize)
            if photos.count > 0 {
                return photos
            }
            
            //Fetch remote data
            photos = try await remoteDataSource.loadPhotos(pageNumber: pageNumber, pageSize: pageSize)
            
            //Save the photos to local database
            try await localDataSource.savePhotos(photos)
            
            return photos
        } catch {
            throw error
        }
    }
}
