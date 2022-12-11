//
//  HomeView.swift
//  FetchingOTP
//
//  Created by 程信傑 on 2022/12/10.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var otpModel: OTPViewModel

    var body: some View {
        VStack {
            Text("Home page")
            if case let OTPViewModel.State.signedIn(user) = otpModel.state {
                Text("I am \(user)")
            }

            Button {
                otpModel.signOut()
                coordinator.goToRoot()
            } label: {
                Text("Logout")
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Home")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
