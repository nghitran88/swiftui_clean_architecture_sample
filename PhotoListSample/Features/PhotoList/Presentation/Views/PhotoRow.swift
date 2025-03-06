//
//  PhotoRow.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 15/2/25.
//

import SwiftUI

struct PhotoRow: View {
    let photo: Photo

    var body: some View {
        HStack {
            PhotoView(imageUrl: URL(string: photo.thumbnailUrl)).cornerRadius(25)
            
            Text(photo.title)
                .font(.headline)
                .lineLimit(2)
                .accessibilityIdentifier("\(Constants.UIComponentIDs.photoListCell)\(photo.id)")

            Spacer()

            Image(systemName: photo.isFavorite ? "star.fill" : "star")
                .foregroundStyle(.tint)
            
            Image(systemName: "chevron.right").foregroundColor(.secondary)
        }
    }
}
