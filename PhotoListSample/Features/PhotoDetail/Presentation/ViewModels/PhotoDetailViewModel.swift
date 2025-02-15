//
//  PhotoDetailViewModel.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation
import Combine

enum PhotoDetailFilterMode {
    case none
    case favorite
}

enum PhotoDetailViewStatus: Equatable {
    case idle
    case loading
    case loaded
    case failed
}

protocol PhotoDetailViewModelProtocol: ObservableObject {
    var photo: Photo? { get }
    var photoID: Int64 { get }
    var loadingStatus: PhotoDetailViewStatus { get }
    var errorMessage: String?  { get }

    func fetchPhoto()
    func toggleFavorite()
}

class PhotoDetailViewModel: PhotoDetailViewModelProtocol {
    
    @Published private(set) var photo: Photo?
    @Published private(set) var loadingStatus: PhotoDetailViewStatus = .idle
    @Published private(set) var errorMessage: String?
    
    private(set) var photoID: Int64
    private let photoDetailInteractor: PhotoDetailInteractorProtocol
    
    init(photoID: Int64, interactor: PhotoDetailInteractorProtocol) {
        self.photoID = photoID
        self.photoDetailInteractor = interactor
    }

    func fetchPhoto() {
        Task {
            await self.updateLoadingStatus(.loading)
            
            do {
                let photo = try await self.photoDetailInteractor.loadPhoto(id: photoID)
                await updatePhoto(photo)
            }  catch {
                await self.updateLoadingStatus(.failed)
                await self.updateErrorMessage("Failed to load the photo detail from local database: " + error.localizedDescription)
            }
        }
    }

    func toggleFavorite() {
        guard let photo = self.photo, photo.id > 0 else {
            return
        }
        
        Task {
            do {
                let updatedPhoto = Photo(
                    albumId: photo.albumId,
                    id: photo.id,
                    title: photo.title,
                    url: photo.url,
                    thumbnailUrl: photo.thumbnailUrl,
                    isFavorite: !photo.isFavorite
                )
                _ = try await self.photoDetailInteractor.updatePhoto(updatedPhoto)
                await self.updatePhoto(updatedPhoto)
            }  catch {
                await self.updateErrorMessage("Failed to load the photo detail from local database: " + error.localizedDescription)
            }
        }
    }
}

// MARK: - Private methods

private extension PhotoDetailViewModel {
    @MainActor
    func updateLoadingStatus(_ status: PhotoDetailViewStatus) {
        self.loadingStatus = status
    }
    
    @MainActor
    func updatePhoto(_ photo: Photo?) {
        self.photo = photo
        if photo == nil {
            self.loadingStatus = .failed
            self.errorMessage = "Failed to load the photo detail from local database"
        } else {
            self.loadingStatus = .loaded
            self.notifyPhotoUpdated()
        }
    }
    
    @MainActor
    func updateErrorMessage(_ errorMessage: String) {
        self.errorMessage = errorMessage
    }
}

// MARK: - Notification

private extension PhotoDetailViewModel {
    func notifyPhotoUpdated() {
        NotificationCenter.default.post(name: .photoUpdated, object: photoID)
    }
}
