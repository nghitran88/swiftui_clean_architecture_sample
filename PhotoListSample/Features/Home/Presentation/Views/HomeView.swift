//
//  HomeView.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        VStack {
            Button {
                coordinator.push(page: .photoList)
            } label: {
                Text("Go to Photo List")
                    .font(Constants.Fonts.defaultButtonFont)
                    .foregroundStyle(Constants.Colors.defaultButtonTitle)
                    .padding(Constants.Layout.defaultPadding)
            }
            .frame(maxWidth: .infinity)
            .background(Constants.Colors.defaultButtonBackground)
            .clipShape(.buttonBorder)
            .accessibilityIdentifier(Constants.UIComponentIDs.goToPhotoListButton)
        }
        .padding(Constants.Layout.defaultPadding)
        .navigationTitle("Photo App")
    }
}

#Preview {
    HomeView()
}
