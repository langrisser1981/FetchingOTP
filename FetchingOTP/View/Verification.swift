//
//  Verification.swift
//  FetchingOTP
//
//  Created by 程信傑 on 2022/12/9.
//

import SwiftUI

struct Verification: View {
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var otpModel: OTPViewModel
    @FocusState var activeField: OTPField?

    var body: some View {
        VStack {
            OTPField()

            Button {
                Task {
                    await otpModel.verifyOTP()
                }
            } label: {
                if otpModel.isLoading {
                    ProgressView()
                } else {
                    Text("Verify")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.blue)
                    .opacity(otpModel.isLoading ? 0.4 : 1)
            }
            .disabled(!isFieldAllFilled())
            .opacity(isFieldAllFilled() ? 1 : 0.4)

            Button {
                otpModel.otpFields[0] = "123456"
            } label: {
                Text("AutoFill")
                    .foregroundColor(.red)
            }
        }
        .onChange(of: otpModel.otpFields) { newValue in
            updateField(value: newValue)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationBarBackButtonHidden()
        .navigationTitle("Verification")
        .alert(otpModel.errorMsg, isPresented: $otpModel.showError) {}
    }

    func isFieldAllFilled() -> Bool {
        for index in 0 ... 5 {
            if otpModel.otpFields[index].isEmpty { return false }
        }
        return true
    }

    func updateField(value: [String]) {
        for index in 0 ... 5 {
            if value[index].count == 6 {
                otpModel.otpText = value[index]
                otpModel.otpFields[index] = ""

                for item in otpModel.otpText.enumerated() {
                    otpModel.otpFields[item.offset] = String(item.element)
                }
                return
            }
        }

        for index in 0 ... 5 {
            if value[index].count > 1 {
                let char = value[index].last ?? " "
                otpModel.otpFields[index] = String(char)
            }
        }
        for index in 0 ... 4 {
            if value[index].count == 1, activeField == getFieldForIndex(index: index) {
                activeField = getFieldForIndex(index: index + 1)
            }
        }
        for index in 1 ... 5 {
            if value[index].isEmpty, !value[index-1].isEmpty {
                activeField = getFieldForIndex(index: index-1)
            }
        }
    }

    @ViewBuilder
    func OTPField() -> some View {
        HStack(spacing: 14) {
            ForEach(0 ..< 6, id: \.self) { index in
                VStack(spacing: 8) {
                    TextField("", text: $otpModel.otpFields[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .focused($activeField, equals: getFieldForIndex(index: index))

                    Rectangle()
                        .fill(activeField == getFieldForIndex(index: index) ? .blue : .gray.opacity(0.3))
                        .frame(height: 4)
                }
                .frame(width: 40)
            }
        }
    }

    func getFieldForIndex(index: Int) -> OTPField {
        switch index {
        case 0: return .field1
        case 1: return .field2
        case 2: return .field3
        case 3: return .field4
        case 4: return .field5
        default: return .field6
        }
    }
}

enum OTPField {
    case field1
    case field2
    case field3
    case field4
    case field5
    case field6
}

struct Verification_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Optional {
    func or(defaultValue: Wrapped) -> Wrapped {
        switch self {
        case .none:
            return defaultValue
        case let .some(value):
            return value
        }
    }
}
