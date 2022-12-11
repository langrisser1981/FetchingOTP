//
//  Coordinator.swift
//  FetchingOTP
//
//  Created by 程信傑 on 2022/12/10.
//

import Combine
import SwiftUI

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()

    func goToHome() {
        path.append(Destination.home)
    }

    func goToLogin() {
        path.append(Destination.login)
    }

    func goToVerification() {
        path.append(Destination.verification)
    }

    func goToRoot() {
        path.removeLast(path.count)
    }
}
