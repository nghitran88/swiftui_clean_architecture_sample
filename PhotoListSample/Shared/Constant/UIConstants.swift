//
//  UIConstants.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 20/1/25.
//

import Foundation
import SwiftUICore

extension Constants {
    enum Layout {
        static let defaultPadding: CGFloat = 16
        static let defaultPageSize: Int = 20
    }
    
    enum Colors {
        static let primary = Color.primary
        static let secondary = Color.secondary
        static let detailedTextColor = Color.black
        static let defaultButtonTitle = Color.white
        static let defaultButtonBackground = Color.blue
    }
    
    enum Fonts {
        static let defaultButtonFont = Font.title3
    }
}

// MARK: - UI Tests

extension Constants {
    enum UIComponentIDs {
        static let goToPhotoListButton: String = "GoToPhotoList"
        static let photoListCell: String = "PhotoListCell_"
        static let photoListScreenTitle: String = "PhotoListScreenTitle"
        static let photoDetailScreenTitle: String = "PhotoDetailScreenTitle"
    }
}
