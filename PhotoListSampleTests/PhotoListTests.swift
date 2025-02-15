//
//  PhotoListTests.swift
//  PhotoListSampleTests
//
//  Created by Nghi Tran on 22/1/25.
//

import XCTest
import Combine
@testable import PhotoListSample

final class PhotoListTests: XCTestCase {
    var photoListViewModel: PhotoListViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
        cancellables.removeAll()
    }
    
    func testLoadPhotosSuccess() throws {
        //Create mock data source
        let mockRemoteDataSource = PhotoListRemoteDataSourceMockSuccess()
        let mockLocalDataSource = PhotoListLocalDataSourceMockSuccess()
        let mockPhotoDetailLocalDataSource = PhotoDetailLocalDataSourceMockSuccess()
        
        //Create real objects to test
        let photoListRepository = PhotoListRepository(
            localDataSource: mockLocalDataSource,
            remoteDataSource: mockRemoteDataSource)
        let photoDetailRepository = PhotoDetailRepository(
            localDataSource: mockPhotoDetailLocalDataSource)
        
        let fetchPhotosUseCase = FetchPhotosUseCase(repository: photoListRepository)
        let loadPhotoDetailUseCase = LoadPhotoDetailUseCase(repository: photoDetailRepository)
        
        let photoListInteractor = PhotoListInteractor(
            fetchPhotosUseCase: fetchPhotosUseCase,
            loadPhotoDetailUseCase: loadPhotoDetailUseCase)
        photoListViewModel = PhotoListViewModel(interactor: photoListInteractor)
        
        //Start testing
        let expectation = XCTestExpectation(description: "Wait for photos to be loaded")
        photoListViewModel.$filteredPhotos
            .dropFirst()
            .sink { photos in
                if !photos.isEmpty {
                    XCTAssertEqual(photos.count, 10)
                    XCTAssertEqual(photos.first?.title, "accusamus beatae ad facilis cum similique qui sunt")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        photoListViewModel.fetchPhotos()
                
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadPhotosFailedByRemote() throws {
        //Create mock data source
        let mockRemoteDataSource = PhotoListRemoteDataSourceMockFailure()
        let mockLocalDataSource = PhotoListLocalDataSourceMockFailure()
        let mockPhotoDetailLocalDataSource = PhotoDetailLocalDataSourceMockFailure()
        
        //Create real objects to test
        let photoListRepository = PhotoListRepository(
            localDataSource: mockLocalDataSource,
            remoteDataSource: mockRemoteDataSource)
        let photoDetailRepository = PhotoDetailRepository(
            localDataSource: mockPhotoDetailLocalDataSource)
        
        let fetchPhotosUseCase = FetchPhotosUseCase(repository: photoListRepository)
        let loadPhotoDetailUseCase = LoadPhotoDetailUseCase(repository: photoDetailRepository)
        
        let photoListInteractor = PhotoListInteractor(
            fetchPhotosUseCase: fetchPhotosUseCase,
            loadPhotoDetailUseCase: loadPhotoDetailUseCase)
        photoListViewModel = PhotoListViewModel(interactor: photoListInteractor)
        
        //Start testing
        let expectation = XCTestExpectation(description: "API call is failed")
        photoListViewModel.$loadingStatus
            .dropFirst()
            .sink { status in
                if status != .idle && status != .loading {
                    XCTAssertEqual(status, .failed)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        photoListViewModel.fetchPhotos()
                
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadPhotosFailedByLocalStore() throws {
        //Create mock data source
        let mockRemoteDataSource = PhotoListRemoteDataSourceMockSuccess()
        let mockLocalDataSource = PhotoListLocalDataSourceMockFailure()
        let mockPhotoDetailLocalDataSource = PhotoDetailLocalDataSourceMockFailure()
        
        //Create real objects to test
        let photoListRepository = PhotoListRepository(
            localDataSource: mockLocalDataSource,
            remoteDataSource: mockRemoteDataSource)
        let photoDetailRepository = PhotoDetailRepository(
            localDataSource: mockPhotoDetailLocalDataSource)
        
        let fetchPhotosUseCase = FetchPhotosUseCase(repository: photoListRepository)
        let loadPhotoDetailUseCase = LoadPhotoDetailUseCase(repository: photoDetailRepository)
        
        let photoListInteractor = PhotoListInteractor(
            fetchPhotosUseCase: fetchPhotosUseCase,
            loadPhotoDetailUseCase: loadPhotoDetailUseCase)
        photoListViewModel = PhotoListViewModel(interactor: photoListInteractor)
        
        //Start testing
        let expectation = XCTestExpectation(description: "Failed to save remote data to local database")
        photoListViewModel.$loadingStatus
            .dropFirst()
            .sink { status in
                if status != .idle && status != .loading {
                    XCTAssertEqual(status, .failed)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        photoListViewModel.fetchPhotos()
                
        wait(for: [expectation], timeout: 1.0)
    }
}
