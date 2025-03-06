//
//  PhotoListView.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import SwiftUI
import Kingfisher

struct PhotoListView<T: PhotoListViewModelProtocol>: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject var viewModel: T
    @State private var searchText = ""
    
    var body: some View {
        Group {
            switch viewModel.loadingStatus {
            case .idle, .loading:
                buildLoadingView()
            case .loaded, .loadingMore:
                buildPhotoListView()
            case .failed:
                buildErrorView()
            }
        }
        .navigationTitle(viewModel.filterMode == .all ? "Photo List" : "Photo List(Favorite)")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        changePhotoFilterMode()
                    },
                    label: {
                        Label("Favorite filter", systemImage: viewModel.filterMode == .favorite ? "star.fill" : "star")
                    }
                )
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            loadData()
        }
    }
}

private extension PhotoListView {
    private func loadData() {
        if viewModel.loadingStatus == .idle {
            viewModel.fetchPhotos()
        }
    }
    
    private func changePhotoFilterMode() {
        viewModel.toggleFavorite()
    }
    
    private func searchPhotos() {
        viewModel.searchPhotos(text: searchText)
    }
    
    @ViewBuilder
    func buildPhotoListView() -> some View {
        List{
            ForEach(viewModel.filteredPhotos) { photo in
                PhotoRow(photo: photo)
                .frame(height: 50)
                .onTapGesture {
                    coordinator.push(page: .photoDetail(photoID: photo.id))
                }
                .onAppear {
                    if photo == viewModel.filteredPhotos.last
                        && viewModel.hasMorePages
                        && viewModel.loadingStatus != .loadingMore
                    {
                        print("Loading more at ID: \(photo.id)")
                        print("Current item count: \(viewModel.filteredPhotos.count)")
                        viewModel.loadMorePhotos()
                    }
                }
            }
            
            if viewModel.loadingStatus == .loadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .listStyle(PlainListStyle())
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Photo")
        .onSubmit(of: .search, searchPhotos)
        .onChange(of: searchText, { _, _ in
            searchPhotos()
        })
    }
    
    @ViewBuilder
    func buildLoadingView() -> some View {
        ProgressView("Loading photos...")
                                .progressViewStyle(CircularProgressViewStyle())
    }
    
    @ViewBuilder
    func buildErrorView() -> some View {
        Text(viewModel.errorMessage ?? "")
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
    }
}
