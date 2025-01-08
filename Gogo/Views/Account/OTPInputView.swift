//
//  OTPInputView.swift
//  Gogo
//
//  Created by Xian Yin on 12/28/24.
//

import SwiftUI

struct OTPInputView: View {
    let phoneNumber: String // 传递的电话号码
    let countryCode: String
    
    @State private var otp: [String] = Array(repeating: "", count: 4) // 验证码的每一位
    @State private var isResendEnabled = false // 控制重新发送按钮
    @State private var countdown = 50 // 倒计时时长
    @FocusState private var focusedField: Int? // 当前焦点的输入框
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // 获取电话号码后四位
    private var lastFourDigits: String {
        String(phoneNumber.suffix(4))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 标题
            Text("Enter the verification code")
                .font(.headline)
                .foregroundColor(.black)
            
            // 提示手机号后四位
            Text("A code has been sent to your phone ending in \(lastFourDigits).")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // 验证码输入框
            HStack(spacing: 10) {
                ForEach(0..<4, id: \.self) { index in
                    TextField("", text: $otp[index])
                        .font(.title)
                        .frame(width: 50, height: 50)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .focused($focusedField, equals: index) // 管理焦点
                        .onChange(of: otp[index]) { _, newValue in
                            handleInputChange(newValue: newValue, index: index)
                        }
                }
            }
            
            // 重新发送按钮
            Button(action: resendCode) {
                if isResendEnabled {
                    Text("Resend code")
                        .foregroundColor(.blue)
                } else {
                    Text("Resend code in (\(countdown)s)")
                        .foregroundColor(.gray)
                }
            }
            .disabled(!isResendEnabled)
            
            Spacer()
        }
        .padding()
        .onAppear {
            startCountdown()
        }
    }
    
    // 验证码输入逻辑处理
    private func handleInputChange(newValue: String, index: Int) {
        if newValue.count > 1 { // 限制每格只能输入1位
            otp[index] = String(newValue.prefix(1))
        }
        // 自动跳转到下一个输入框
        if !newValue.isEmpty, index < 3 {
            focusedField = index + 1
        }
    }
    
    // 开始倒计时
    private func startCountdown() {
        isResendEnabled = false
        countdown = 50
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            countdown -= 1
            if countdown <= 0 {
                timer.invalidate()
                isResendEnabled = true
            }
        }
    }
    
    // 重新发送验证码
    private func resendCode() {
        NetworkService.shared.sendVerificationCode(phoneNumber: phoneNumber, country: countryCode) { result in
            switch result {
            case .success:
                alertMessage = "Verification code resent successfully"
            case .failure(let error):
                alertMessage = "Failed to resend verification code: \(error.localizedDescription)"
            }
            showAlert = true
            startCountdown()
        }
    }
}

struct OTPInputView_Previews: PreviewProvider {
    static var previews: some View {
        OTPInputView(phoneNumber: "18888886766", countryCode: "1")
    }
}
