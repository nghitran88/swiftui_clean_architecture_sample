//
//  PhotoListDIContainer.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

protocol PhotoListDIContainerProtocol {
    associatedtype T: PhotoListViewModelProtocol
    func makePhotoListView() -> PhotoListView<T>
}

final class PhotoListDIContainer: PhotoListDIContainerProtocol {
    typealias T = PhotoListViewModel

    func makePhotoListView() -> PhotoListView<T> {
        let networkService = NetworkService()
        let localDataSource = PhotoListLocalDataSource()
        let remoteDataSource = PhotoListRemoteDataSource(networkService: networkService)
        let repository = PhotoListRepository(localDataSource: localDataSource, remoteDataSource: remoteDataSource)
        let fetchPhotosUseCase = FetchPhotosUseCase(repository: repository)
        
        let detailLocalDataSource = PhotoDetailLocalDataSource()
        let detailRepository = PhotoDetailRepository(localDataSource: detailLocalDataSource)
        let loadPhotoDetailUseCase = LoadPhotoDetailUseCase(repository: detailRepository)
        
        let photoListInteractor: PhotoListInteractor = PhotoListInteractor(
            fetchPhotosUseCase: fetchPhotosUseCase,
            loadPhotoDetailUseCase: loadPhotoDetailUseCase)
        let viewModel = PhotoListViewModel(interactor: photoListInteractor)
        return PhotoListView(viewModel: viewModel)
    }
}
