//
//  AppScreens.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 20/1/25.
//

import Foundation

enum AppScreens: Hashable {
    case home
    case photoList
    case photoDetail(photoID: Int64)
}

enum Sheet: Identifiable {
    var id: String {
        switch self {
        case .photoList:
            return Constants.ScreenIdentifiers.photoList
        case .photoDetail:
            return Constants.ScreenIdentifiers.photoDetail
        }
    }
    
    case photoList
    case photoDetail(photoID: Int64)
}

enum FullScreenCover: Identifiable {
    var id: String {
        switch self {
        case .photoList:
            return Constants.ScreenIdentifiers.photoList
        case .photoDetail:
            return Constants.ScreenIdentifiers.photoDetail
        }
    }
    
    case photoList
    case photoDetail(photoID: Int64)
}
