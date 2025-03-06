//
//  PhotoListRemoteDataSource.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

protocol PhotoListRemoteDataSourceProtocol {
    func loadPhotos(pageNumber: Int, pageSize: Int) async throws -> [Photo]
}

final class PhotoListRemoteDataSource: PhotoListRemoteDataSourceProtocol {
    internal let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func loadPhotos(pageNumber: Int, pageSize: Int) async throws -> [Photo] {
        let photoDTOs = try await fetchPhotos(pageNumber: pageNumber, pageSize: pageSize)
        return photoDTOs.compactMap { $0.toDomain() }
    }
}

private extension PhotoListRemoteDataSource {
    func fetchPhotos(pageNumber: Int, pageSize: Int) async throws -> [PhotoRemoteDTO] {
        let networkConfig = PhotoListAPIConfig.list(pageNumber: pageNumber, pageSize: pageSize)
        return try await networkService.request(config: networkConfig)
    }
}

enum PhotoListAPIConfig: NetworkConfig {
    case list(pageNumber: Int, pageSize: Int)

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
        case .list(let pageNumber, let pageSize): .requestParameters(["_page": pageNumber, "_limit": pageSize])
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list: .get
        }
    }
}
