//
//  PasswordInputView.swift
//  Gogo
//
//  Created by Xian Yin on 12/28/24.
//
import SwiftUI

struct PasswordInputView: View {
    let phoneNumber: String
    let countryCode: String
    
    @State private var password: String = ""
    @State private var loginMessage: String = ""
    @State private var isLoading: Bool = false
    @State private var navigateToMainView = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
            VStack(spacing: 20) {
                Text("Enter Password")
                    .font(.headline)
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                Button(action: {
                    isLoading = true
                    UserService.shared.login(phoneNumber: countryCode + phoneNumber, password: password) { result in
                        DispatchQueue.main.async {
                            isLoading = false
                            switch result {
                            case .success(let message):
                                loginMessage = message
                                navigateToMainView = true
                            case .failure(let error as NSError):
                                // 输出 msg 的内容
                                alertMessage = error.domain
                                showAlert = true
                            }
                        }
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("Login")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .disabled(isLoading)

                Text(loginMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            .padding()
            .alert(alertMessage, isPresented: $showAlert, actions: {
                Button("OK", role: .cancel) { }
            })
            .navigationDestination(isPresented: $navigateToMainView) {
//                PassengerMainView()
            }
        }
}

#Preview {
    PasswordInputView(phoneNumber: "650 430 3426", countryCode: "1")
}
