//
//  ContentView.swift
//  FetchingOTP
//
//  Created by 程信傑 on 2022/12/9.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("logStatus") var logStatus = false

    @StateObject var coordinator = Coordinator()
    @StateObject var otpModel = OTPViewModel()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                if logStatus == true {
                    HomeView()
                } else {
                    LoginView()
                }
                /*
                 Spacer()
                 Button {
                     fatalError("測試強制崩潰")
                 } label: {
                     Text("測試")
                 }
                  */
            }
            .onChange(of: otpModel.state) { state in
                switch state {
                case .signedIn(let user):
                    print("\(user.phoneNumber.or(defaultValue: "無號碼")) :已登入")
                    coordinator.goToHome()
                case .verify:
                    coordinator.goToVerification()
                case .signedOut:
                    coordinator.goToLogin()
                }
            }
            .navigationDestination(for: Destination.self) { destination in
                ViewFactory.viewForDestination(destination)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .environmentObject(coordinator)
        .environmentObject(otpModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
