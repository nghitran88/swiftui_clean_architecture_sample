//
//  PhotoView.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 13/2/25.
//

import SwiftUI
import Kingfisher

enum ImageDownloadStatus: Equatable {
    case initialized
    case downloading
    case success
    case failed
}

struct PhotoView: View {
    let imageUrl: URL?
    @State private var downloadStatus: ImageDownloadStatus = .initialized
    @State private var timer: Timer?

    
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
    
    var body: some View {
        KFImage.url(imageUrl)
            .placeholder { progress in
                ZStack {
                    Circle()
                        .stroke(lineWidth: 5)
                        .opacity(0.3)
                        .foregroundColor(.gray)

                    Circle()
                        .trim(from: 0.0, to: progress.fractionCompleted)
                        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .foregroundColor(.blue)
                        .rotationEffect(Angle(degrees: -90))
                        .animation(.linear, value: progress.fractionCompleted)

                    Text("\(Int(progress.fractionCompleted * 100))%")
                        .font(.caption)
                        .bold()

                }
                    .frame(height: 40)
                    .opacity((downloadStatus == .downloading || downloadStatus == .initialized) ? 1 : 0)
            }
            .loadDiskFileSynchronously(true)
            .cacheMemoryOnly(false)
            .fade(duration: 0.25)
            .onSuccess { result in  }
            .onFailure { error in
                downloadStatus = .failed
            }
            .onFailureImage(
                UIImage(named: "no-image-placeholder")
            )
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onAppear {
                downloadStatus = .downloading
            }
    }
}
