//
//  PhotoLocalDataSource.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation
import CoreData

protocol PhotoListLocalDataSourceProtocol {
    func savePhotos(_ photos: [Photo]) async throws -> Void
    func loadPhotos() async throws -> [Photo]
}

final class PhotoListLocalDataSource: PhotoListLocalDataSourceProtocol {
    private let coreDataStack: CoreDataStackProtocol

    init(coreDataStack: CoreDataStackProtocol = CoreDataStack.shared) {
        self.coreDataStack = coreDataStack
    }
    
    func savePhotos(_ photos: [Photo]) async throws -> Void {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStack.performBackgroundTask { context in
                do {
                    for photo in photos {
                        //TODO: Consider to check photo exist to prevent DB error
                        
                        let coreDataPhoto = CDPhoto(context: context)
                        coreDataPhoto.albumId = Int64(photo.albumId)
                        coreDataPhoto.id = Int64(photo.id)
                        coreDataPhoto.title = photo.title
                        coreDataPhoto.url = photo.url
                        coreDataPhoto.thumbnailUrl = photo.thumbnailUrl
                        coreDataPhoto.isFavorite = photo.isFavorite
                    }

                    try context.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func loadPhotos() async throws -> [Photo] {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStack.performBackgroundTask { context in
                do {
                    let cdPhotos = try self.fetchAllPhotos(in: context)
                    let photos = cdPhotos.compactMap({ $0.toDomain() })
                    continuation.resume(returning: photos)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

// MARK: - Utils

private extension PhotoListLocalDataSource {
    func fetchAllPhotos(in context: NSManagedObjectContext) throws -> [CDPhoto] {
        let fetchRequest = CDPhoto.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        let cdPhotos = try context.fetch(fetchRequest)
        return cdPhotos
    }
    
    func fetchPhoto(by id: Int64, in context: NSManagedObjectContext) throws -> CDPhoto? {
        let fetchRequest = CDPhoto.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: Constants.photoIdPredicate, id)
        fetchRequest.fetchLimit = 1

        return try context.fetch(fetchRequest).first
    }
}

// MARK: - Constants

private extension PhotoListLocalDataSource {
    enum Constants {
        static let textPredicate = "title =[c] %@"
        static let photoIdPredicate = "id = %d"
        static let favoritePredicate = "isFavorite = %@"
        static let textAndFavoritePredicate = "\(textPredicate) AND \(favoritePredicate)"
    }
}
