//
//  LoginView.swift
//  FetchingOTP
//
//  Created by 程信傑 on 2022/12/9.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var otpModel: OTPViewModel

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                VStack(spacing: 8) {
                    TextField("code", text: $otpModel.code)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                    Rectangle()
                        .fill(otpModel.code.isEmpty ? .gray.opacity(0.3) : .blue)
                        .frame(height: 2)
                }
                .frame(height: 40)

                VStack(spacing: 8) {
                    TextField("963091621", text: $otpModel.number)
                        .keyboardType(.numberPad)
                    // .multilineTextAlignment(.center)
                    Rectangle()
                        .fill(otpModel.number.isEmpty ? .gray.opacity(0.3) : .blue)
                        .frame(height: 2)
                }
                .frame(height: 40)
            }
            .padding()

            Button {
                Task {
                    await otpModel.sendOTP()
                }
            } label: {
                if otpModel.isLoading {
                    ProgressView()
                } else {
                    Text("Login")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.blue)
                    .opacity(otpModel.isLoading ? 0.4 : 1)
            }
            .disabled(otpModel.code.isEmpty || otpModel.number.isEmpty)
            .opacity(otpModel.code.isEmpty || otpModel.number.isEmpty ? 0.4 : 1)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle("Login")
        .alert(otpModel.errorMsg, isPresented: $otpModel.showError) {}
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
