//
//  AppCoordinator.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//


import Foundation
import SwiftUI

class AppCoordinator: ObservableObject {
    @Published var path: NavigationPath
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    let diContainer: AppDIContainer
    
    init(path: NavigationPath = NavigationPath(), sheet: Sheet? = nil, fullScreenCover: FullScreenCover? = nil, diContainer: AppDIContainer) {
        self.path = path
        self.sheet = sheet
        self.fullScreenCover = fullScreenCover
        self.diContainer = diContainer
    }
    
    func push(page: AppScreens) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func presentFullScreenCover(_ cover: FullScreenCover) {
        self.fullScreenCover = cover
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissCover() {
        self.fullScreenCover = nil
    }
    
    @ViewBuilder
    func build(page: AppScreens) -> some View {
        switch page {
        case .home: HomeView()
        case .photoList: diContainer.makePhotoListDIContainer().makePhotoListView()
        case .photoDetail(let id): diContainer.makePhotoDetailDIContainer().makePhotoDetailView(withPhotoID: id)
        }
    }
    
    @ViewBuilder
    func buildSheet(sheet: Sheet) -> some View {
        switch sheet {
        case .photoList:diContainer.makePhotoListDIContainer().makePhotoListView()
        case .photoDetail(let id): diContainer.makePhotoDetailDIContainer().makePhotoDetailView(withPhotoID: id)
        }
    }
    
    @ViewBuilder
    func buildCover(cover: FullScreenCover) -> some View {
        switch cover {
        case .photoList:diContainer.makePhotoListDIContainer().makePhotoListView()
        case .photoDetail(let id): diContainer.makePhotoDetailDIContainer().makePhotoDetailView(withPhotoID: id)
        }
    }
}
