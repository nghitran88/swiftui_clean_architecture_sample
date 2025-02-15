//
//  DIContainer.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

final class AppDIContainer {
    func makePhotoListDIContainer() -> PhotoListDIContainer {
        return PhotoListDIContainer()
    }
    
    func makePhotoDetailDIContainer() -> PhotoDetailDIContainer {
        return PhotoDetailDIContainer()
    }
}
