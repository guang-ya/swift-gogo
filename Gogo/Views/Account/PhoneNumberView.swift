//
//  PhoneNumberView.swift
//  Gogo
//
//  Created by Xian Yin on 12/27/24.
//

import SwiftUI

struct PhoneNumberView: View {
    @State private var selectedCountry = "US"
    @State private var phoneNumber: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToOTPInputView = false
    @State private var navigateToPasswordInputView = false

    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "car.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.top, 100)

                Text("Welcome to Gogo")
                    .font(.largeTitle)
                    .padding()

                TextField("Phone Number", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.phonePad)

                Button(action: {
                    queryUser()
                }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationDestination(isPresented: $navigateToOTPInputView) {
                OTPInputView(phoneNumber: phoneNumber,countryCode: "1")
            }
            .navigationDestination(isPresented: $navigateToPasswordInputView) {
                PasswordInputView(phoneNumber: phoneNumber, countryCode: "1")
            }
        }
    }

    private func queryUser() {
        guard isValidUSPhoneNumber(phoneNumber) else {
            alertMessage = "Please enter a valid US phone number"
            showAlert = true
            return
        }
        
        UserService.shared.queryUser(by: "1" + phoneNumber) { result in
            switch result {
            case .success(let isNewUser):
                if isNewUser {
                    navigateToOTPInputView = true
                    NetworkService.shared.sendVerificationCode(phoneNumber: phoneNumber, country: "1") { result in
                        switch result {
                        case .success:
                            navigateToOTPInputView = true
                        case .failure(let error):
                            alertMessage = "Failed to send verification code: \(error.localizedDescription)"
                            showAlert = true
                        }
                    }
                } else {
                    navigateToPasswordInputView = true
                }
            case .failure(let error):
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
    
    /// 验证美国手机号码是否为正确格式
    /// - Parameter phoneNumber: 输入的手机号码（字符串）
    /// - Returns: 返回 `true` 表示号码格式正确，`false` 表示格式错误
    func isValidUSPhoneNumber(_ phoneNumber: String) -> Bool {
        // 检查是否是纯数字
        let numericSet = CharacterSet.decimalDigits
        if phoneNumber.rangeOfCharacter(from: numericSet.inverted) != nil {
            return false // 包含非数字字符
        }
        
        // 检查号码长度是否为10位
        if phoneNumber.count != 10 {
            return false // 美国号码长度固定为10位
        }
        
        return true // 格式正确
    }
}

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView()
    }
}
