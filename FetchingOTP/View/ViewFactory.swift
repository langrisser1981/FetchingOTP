//
//  ViewFactory.swift
//  FetchingOTP
//
//  Created by 程信傑 on 2022/12/10.
//

import Foundation
import SwiftUI

class ViewFactory {
    @ViewBuilder
    static func viewForDestination(_ destination: Destination) -> some View {
        switch destination {
        case .login:
            LoginView()
        case .verification:
            Verification()
        default:
            HomeView()
        }
    }
}

enum Destination {
    case home
    case login
    case verification
}
