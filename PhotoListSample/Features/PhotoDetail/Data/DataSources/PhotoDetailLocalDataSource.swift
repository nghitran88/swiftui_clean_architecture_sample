//
//  PhotoDetailLocalDataSource.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation
import CoreData

enum PhotoDetailLocalError: Error {
    case photoNotExist
}

protocol PhotoDetailLocalDataSourceProtocol {
    func updatePhoto(_ photo: Photo) async throws -> Bool
    func loadPhoto(id: Int64) async throws -> Photo?
}

final class PhotoDetailLocalDataSource: PhotoDetailLocalDataSourceProtocol {
    private let coreDataStack: CoreDataStackProtocol

    init(coreDataStack: CoreDataStackProtocol = CoreDataStack.shared) {
        self.coreDataStack = coreDataStack
    }
    
    func updatePhoto(_ photo: Photo) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStack.performBackgroundTask { context in
                do {
                    guard let existPhoto = try self.fetchPhoto(by: photo.id, in: context) else {
                        continuation.resume(throwing: PhotoDetailLocalError.photoNotExist)
                        return
                    }
                
                    existPhoto.albumId = Int64(photo.albumId)
                    existPhoto.id = Int64(photo.id)
                    existPhoto.title = photo.title
                    existPhoto.url = photo.url
                    existPhoto.thumbnailUrl = photo.thumbnailUrl
                    existPhoto.isFavorite = photo.isFavorite

                    try context.save()
                    continuation.resume(returning: true)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func loadPhoto(id: Int64) async throws -> Photo? {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStack.performBackgroundTask { context in
                do {
                    let cdPhoto = try self.fetchPhoto(by: id, in: context)
                    let photo = cdPhoto?.toDomain()
                    continuation.resume(returning: photo)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

// MARK: - Utils

private extension PhotoDetailLocalDataSource {
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

private extension PhotoDetailLocalDataSource {
    enum Constants {
        static let photoIdPredicate = "id = %d"
    }
}
