//
//  OTPViewModel.swift
//  FetchingOTP
//
//  Created by 程信傑 on 2022/12/9.
//

import FirebaseAuth
import SwiftUI

class OTPViewModel: ObservableObject {
    @AppStorage("logStatus") var logStatus = false

    @Published var code: String = "886"
    @Published var number: String = ""
    @Published var otpText: String = ""
    @Published var otpFields: [String] = Array(repeating: "", count: 6)

    @Published var errorMsg: String = ""
    @Published var showError: Bool = false

    @Published var verificationCode: String = ""

    @Published var isLoading = false
    @Published var state: State

    init() {
        if let user = Auth.auth().currentUser {
            print("已登入")
            state = .signedIn(user)
        } else {
            print("未登入")
            state = .signedOut
        }
    }

    func sendOTP() async {
        if isLoading { return }
        await MainActor.run { isLoading = true }

        do {
            // let result = try await PhoneAuthProvider.provider().verifyPhoneNumber("+886963091621", uiDelegate: nil)
            let result = try await PhoneAuthProvider.provider().verifyPhoneNumber("+\(code)\(number)", uiDelegate: nil)
            await MainActor.run(body: {
                isLoading = false
                verificationCode = result
                state = .verify
            })
        } catch {
            handleError(error: error.localizedDescription)
        }
    }

    func verifyOTP() async {
        if isLoading { return }
        await MainActor.run {
            isLoading = true
            otpText = otpFields.reduce("") { partialResult, code in
                partialResult + code
            }
        }

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationCode, verificationCode: otpText)
        do {
            let result = try await Auth.auth().signIn(with: credential)
            // print(result.user.displayName.or(defaultValue: "no display name"))

            await MainActor.run {
                isLoading = false
                logStatus = true
                state = .signedIn(result.user)
            }
        } catch {
            handleError(error: error.localizedDescription)
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            logStatus = false
        } catch {
            handleError(error: error.localizedDescription)
        }
    }

    func handleError(error: String) {
        Task { @MainActor in
            isLoading = false
            errorMsg = error
            showError.toggle()
        }
    }
}

extension OTPViewModel {
    enum State: Equatable {
        case signedIn(User)
        case signedOut
        case verify
    }
}
