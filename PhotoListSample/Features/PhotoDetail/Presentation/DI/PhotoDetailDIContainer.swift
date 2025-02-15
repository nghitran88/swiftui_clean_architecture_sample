//
//  PhotoDetailDIContainer.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

protocol PhotoDetailDIContainerProtocol {
    associatedtype T: PhotoDetailViewModelProtocol
    func makePhotoDetailView(withPhotoID id: Int64) -> PhotoDetailView<T>
}

final class PhotoDetailDIContainer: PhotoDetailDIContainerProtocol {
    typealias T = PhotoDetailViewModel

    func makePhotoDetailView(withPhotoID id: Int64) -> PhotoDetailView<T> {
        let localDataSource = PhotoDetailLocalDataSource()
        let repository = PhotoDetailRepository(localDataSource: localDataSource)
        let loadPhotoUseCase = LoadPhotoDetailUseCase(repository: repository)
        let updatePhotoUseCase = UpdatePhotoDetailUseCase(repository: repository)
        let photoDetailInteractor = PhotoDetailInteractor(
            loadPhotoUseCase: loadPhotoUseCase,
            updatePhotoUseCase: updatePhotoUseCase)
        let viewModel = PhotoDetailViewModel(photoID: id, interactor: photoDetailInteractor)
        return PhotoDetailView(viewModel: viewModel)
    }
}
