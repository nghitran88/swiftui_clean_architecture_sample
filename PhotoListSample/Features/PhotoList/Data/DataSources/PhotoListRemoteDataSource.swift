//
//  PhotoListRemoteDataSource.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

protocol PhotoListRemoteDataSourceProtocol {
    func loadPhotos() async throws -> [Photo]
}

final class PhotoListRemoteDataSource: PhotoListRemoteDataSourceProtocol {
    internal let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func loadPhotos() async throws -> [Photo] {
        let photoDTOs = try await fetchPhotos()
        return photoDTOs.compactMap { $0.toDomain() }
    }
}

private extension PhotoListRemoteDataSource {
    func fetchPhotos() async throws -> [PhotoRemoteDTO] {
        let networkConfig = PhotoListAPIConfig.list
        return try await networkService.request(config: networkConfig)
    }
}

enum PhotoListAPIConfig: NetworkConfig {
    case list

    var path: String {
        Constants.API.baseURL
    }

    var endpoint: String {
        switch self {
        case .list: Constants.API.photosEndpoint
        }
    }

    var task: HTTPTask {
        switch self {
        case .list: .request
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list: .get
        }
    }
}
