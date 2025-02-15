//
//  PhotoDetailView.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import SwiftUI

struct PhotoDetailView<T: PhotoDetailViewModelProtocol>: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject var viewModel: T
    @State private var showConfirmation = false

    var body: some View {
        Group{
            switch viewModel.loadingStatus {
            case .idle, .loading:
                buildLoadingView()
            case .loaded:
                buildPhotoView()
            case .failed:
                buildErrorView()
            }
        }
        .navigationTitle("Photo Detail")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        guard let photo = viewModel.photo else {
                            return
                        }
                        if photo.isFavorite {
                            self.showConfirmation = true
                        } else {
                            self.toggleFavorite()
                        }
                    },
                    label: {
                        Label("Favorite", systemImage: (viewModel.photo?.isFavorite ?? false ) ? "star.fill" : "star")
                    }
                )
                .alert("Are you sure to disklie this photo?", isPresented: $showConfirmation, presenting: viewModel.photo) { photo in
                    Button("Sure", role: .destructive) {
                        self.toggleFavorite()
                    }
                    Button("Cancel", role: .cancel) {}
                }
            }
        }
        .onAppear {
            loadData()
        }
        .accessibilityIdentifier(Constants.UIComponentIDs.photoDetailScreenTitle)
    }
}

private extension PhotoDetailView {
    private func loadData() {
        if viewModel.loadingStatus == .idle {
            viewModel.fetchPhoto()
        }
    }
    
    private func toggleFavorite() {
        guard let _ = viewModel.photo else {
            return
        }
        
        viewModel.toggleFavorite()
    }
    
    @ViewBuilder
    func buildPhotoView() -> some View {
        let photoUrl = viewModel.photo?.url ?? ""
        VStack {
            PhotoView(imageUrl: URL(string: photoUrl))
                .frame(height: 320)
                .padding()
            Text(viewModel.photo?.title ?? "")
                .font(.title)
                .padding()
        }
    }
    
    @ViewBuilder
    func buildLoadingView() -> some View {
        ProgressView("Loading photo...")
                                .progressViewStyle(CircularProgressViewStyle())
    }
    
    @ViewBuilder
    func buildErrorView() -> some View {
        Text(viewModel.errorMessage ?? "")
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
    }
}
