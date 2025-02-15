//
//  PhotoListViewModel.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

enum PhotoListFilterMode {
    case all
    case favorite
}

enum PhotoListViewStatus: Equatable {
    case idle
    case loading
    case loaded
    case failed
}

protocol PhotoListViewModelProtocol: ObservableObject {
    var photos: [Photo] { get }
    var filteredPhotos: [Photo] { get }
    var filterMode: PhotoListFilterMode { get }
    var loadingStatus: PhotoListViewStatus { get }
    var searchText: String { get }
    var errorMessage: String?  { get }

    func fetchPhotos()
    func toggleFavorite()
    func searchPhotos(text: String)
}

class PhotoListViewModel: PhotoListViewModelProtocol {
    private(set) var photos: [Photo] = []
    private(set) var searchText: String = ""
    private(set) var filterMode: PhotoListFilterMode = .all
    
    @Published private(set) var filteredPhotos: [Photo] = []
    @Published private(set) var loadingStatus: PhotoListViewStatus = .idle
    @Published private(set) var errorMessage: String?
    
    private let photoListInteractor: PhotoListInteractorProtocol
    
    init(interactor: PhotoListInteractorProtocol) {
        self.photoListInteractor = interactor
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePhotoUpdate(_:)), name: .photoUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func fetchPhotos() {
        Task {
            await self.updateLoadingStatus(.loading)
            
            do {
                let photos = try await self.photoListInteractor.fetchPhotos()
                self.photos = photos
                
                await self.updateLoadingStatus(.loaded)
                let filteredPhotos = photos
                await self.updateFilteredPhotos(filteredPhotos)
                
                //TODO: Consider to enhance this with pagination/load more
                
            } catch NetworkError.requestFailed(_, _) {
                await self.updateLoadingStatus(.failed)
                await self.updateErrorMessage("Something went wrong with the photo service. Please try again later")
            } catch NetworkError.notConnected {
                await self.updateLoadingStatus(.failed)
                await self.updateErrorMessage("No internet connection")
            } catch {
                await self.updateLoadingStatus(.failed)
                
                //Just show the localizedDescription for demo
                await self.updateErrorMessage("Unknown error: " + error.localizedDescription)
            }
        }
    }

    func toggleFavorite() {
        Task {
            self.filterMode = filterMode == .all ? .favorite : .all
            await self.updateFilteredPhotos(generateFilteredPhotoList())
        }
    }

    func searchPhotos(text: String) {
        Task {
            self.searchText = text
            await self.updateFilteredPhotos(generateFilteredPhotoList())
        }
    }
}

// MARK: - Private methods

private extension PhotoListViewModel {
    @MainActor
    func updateLoadingStatus(_ status: PhotoListViewStatus) {
        self.loadingStatus = status
    }
    
    @MainActor
    func updateFilteredPhotos(_ photos: [Photo]) {
        self.filteredPhotos = photos
    }
    
    @MainActor
    func updateErrorMessage(_ errorMessage: String) {
        self.errorMessage = errorMessage
    }
    
    func generateFilteredPhotoList() -> [Photo] {
        let isFavorite = filterMode == .favorite
        
        var filteredPhoto: [Photo]
        if !searchText.isEmpty && isFavorite {
            filteredPhoto = photos.filter({ $0.isFavorite == isFavorite && $0.title.localizedCaseInsensitiveContains(searchText) })
        } else if !searchText.isEmpty && !isFavorite{
            filteredPhoto = photos.filter({ $0.title.localizedCaseInsensitiveContains(searchText) })
        } else if searchText.isEmpty && isFavorite{
            filteredPhoto = photos.filter({ $0.isFavorite == isFavorite })
        } else {
            filteredPhoto = photos
        }
        
        return filteredPhoto
    }
}

// MARK: - Notification

private extension PhotoListViewModel {
    @objc private func handlePhotoUpdate(_ notification: Notification) {
        guard let photoID = notification.object as? Int64,
              let index = photos.firstIndex(where: { $0.id == photoID }) else {
            return
        }
        
        Task {
            guard let dbPhoto = try await self.photoListInteractor.loadPhotoDetail(withID: photoID) else {
                return
            }
            photos[index] = dbPhoto
            await self.updateFilteredPhotos(generateFilteredPhotoList())
        }
    }
}
