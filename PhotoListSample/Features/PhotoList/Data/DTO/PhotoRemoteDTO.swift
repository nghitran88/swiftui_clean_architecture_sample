//
//  PhotoRemoteDTO.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

struct PhotoRemoteDTO: Codable {
    let albumId: Int64
    let id: Int64
    let title: String
    let url: String
    let thumbnailUrl: String
    
    func toDomain() -> Photo {
        
        /* Change the imanges' url following the tips in the instruction:
         Tips: if cannot download the image from the via.placeholder.com, you can try to replace the via.placeholder.com with dummyimage.com locally.
         */
        
        let dummyUrl = url.replacing("https://via.placeholder.com", with: "https://dummyimage.com")
        let dummyThumbnailUrl = thumbnailUrl.replacing("https://via.placeholder.com", with: "https://dummyimage.com")
        
        return Photo(
            albumId: albumId,
            id: id,
            title: title,
            url: dummyUrl,
            thumbnailUrl: dummyThumbnailUrl,
            isFavorite: false
        )
    }
}
