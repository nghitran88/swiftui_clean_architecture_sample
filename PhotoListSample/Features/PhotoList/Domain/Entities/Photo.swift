//
//  Photo.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

struct Photo: Identifiable, Codable {
    let albumId: Int64
    let id: Int64
    let title: String
    let url: String
    let thumbnailUrl: String
    let isFavorite: Bool
}
