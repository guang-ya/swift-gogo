//
//  CompleteProfileView.swift
//  Gogo
//
//  Created by Xian Yin on 12/27/24.
//



import SwiftUI

struct CompleteProfileView: View {
    @State private var firstName = ""
    @State private var middleName = ""
    @State private var lastName = ""
    @State private var password = ""
    @State private var email = ""
    @State private var showErrorMessage = false
    
    let phoneNumber: String // 从上一个视图传递的手机号
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea() // 浅灰背景
            
            VStack(alignment: .leading, spacing: 24) {
                // 标题部分
                Text("Complete Your Profile")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.systemBlue))
                    .padding(.bottom, 8)
                
                Divider()
                    .background(Color(.systemGray4))
                
                // 输入框区域
                Group {
                    inputField(title: "First Name", isRequired: true, text: $firstName, iconName: "person.fill")
                    inputField(title: "Middle Name (Optional)", isRequired: false, text: $middleName, iconName: "person")
                    inputField(title: "Last Name", isRequired: true, text: $lastName, iconName: "person.fill")
                    inputField(title: "Password", isRequired: true, text: $password, iconName: "lock.fill", isSecure: true)
                    inputField(title: "Email", isRequired: true, text: $email, iconName: "envelope.fill")
                }
                
                // 提交按钮
                Button(action: {
                    if firstName.isEmpty || lastName.isEmpty || password.isEmpty || email.isEmpty {
                        showErrorMessage = true
                    } else {
                        showErrorMessage = false
                        submitProfile()
                    }
                }) {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(.systemBlue), Color(.systemTeal)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: Color(.systemGray3), radius: 4, x: 0, y: 2)
                }
                .padding(.top, 16)
                .scaleEffect(showErrorMessage ? 0.95 : 1.0)
                .animation(.spring(), value: showErrorMessage)
                
                if showErrorMessage {
                    Text("Please fill in all required fields.")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(.top, 8)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color(.systemGray3), radius: 4, x: 0, y: 2)
            .padding()
        }
    }
    
    // 输入框组件
    private func inputField(title: String, isRequired: Bool, text: Binding<String>, iconName: String, isSecure: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if isRequired {
                    Text("*")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            }
            
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                
                if isSecure {
                    SecureField("Enter your \(title.lowercased())", text: text)
                } else {
                    TextField("Enter your \(title.lowercased())", text: text)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).stroke(text.wrappedValue.isEmpty ? Color(.systemGray4) : Color(.systemBlue), lineWidth: 1))
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
        }
    }
    
    // 提交数据到后端
    private func submitProfile() {
        // 校验必填字段
//        guard !firstName.isEmpty, !lastName.isEmpty, !password.isEmpty, !email.isEmpty else {
//            errorMessage = "Please fill in all required fields."
//            showError = true
//            return
//        }

        // 准备请求参数
        let parameters: [String: Any] = [
            "username": firstName + " " + lastName,
            "password": password,
            "email": email,
            "phoneNumber": phoneNumber,
            "fullName": firstName + (middleName.isEmpty ? "" : " \(middleName)") + " \(lastName)",
            "address": "",
            "profilePictureUrl": "",
            "dateOfBirth": "",
            "status": "",
            "stars": 0
        ]
    }
}

struct CompleteProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteProfileView(phoneNumber: "6504303426")
    }
}
