//
//  PhotoLocalDTO.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

extension CDPhoto {
    func toDomain() -> Photo {
        return Photo(
            albumId: self.albumId,
            id: self.id,
            title: self.title ?? "",
            url: self.url ?? "",
            thumbnailUrl: self.thumbnailUrl ?? "",
            isFavorite: self.isFavorite
        )
    }
}
