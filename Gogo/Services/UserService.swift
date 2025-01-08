//
//  UserService.swift
//  Gogo
//
//  Created by Xian Yin on 12/28/24.
//

import SwiftUI
import Alamofire

struct UserService {
    
    static let shared = UserService() // 单例模式，便于统一调用

    private init() {} // 防止外部初始化
    
    func queryUser(by phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = APIConfig.getFullURL(for: APIConfig.findUserByPhoneNumber)
        let parameters: [String: String] = ["phoneNumber": phoneNumber]

        AF.request(url, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: ResponseModel<UserData>.self) { response in
                switch response.result {
                case .success(let userResponse):
                    // 判断 data 是否为 nil
                    if userResponse.data == nil {
                        completion(.success(true))  // 新用户
                    } else {
                        completion(.success(false)) // 已存在用户
                    }
                case .failure(let error):
                    completion(.failure(error))  // 请求失败
                }
            }
    }
    
    /// 用户注册请求
        /// - Parameters:
        ///   - firstName: 用户的名
        ///   - middleName: 用户的中间名（可选）
        ///   - lastName: 用户的姓
        ///   - password: 用户的密码
        ///   - email: 用户的邮箱
        ///   - phoneNumber: 用户的手机号
        ///   - completion: 异步回调，返回成功与否或错误信息
        func registerUser(
            firstName: String,
            middleName: String?,
            lastName: String,
            password: String,
            email: String,
            phoneNumber: String,
            completion: @escaping (Result<Void, Error>) -> Void
        ) {
            // 准备请求参数
            let fullName = firstName + (middleName != nil && !middleName!.isEmpty ? " \(middleName!)" : "") + " \(lastName)"
            let parameters: [String: Any] = [
                "username": fullName,
                "password": password,
                "email": email,
                "phoneNumber": phoneNumber,
                "fullName": fullName,
                "address": "",
                "profilePictureUrl": "",
                "dateOfBirth": "",
                "status": "",
                "stars": 0
            ]

            // API 地址
            let url = APIConfig.getFullURL(for: APIConfig.registerPath)
            
            // 使用 Alamofire 发送请求
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate() // 验证响应是否有效
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        // 请求成功，回调成功
                        completion(.success(()))

                    case .failure(let error):
                        // 请求失败，回调错误
                        completion(.failure(error))
                    }
                }
        }
    
    /// 登录接口
     func login(
        phoneNumber: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let url = APIConfig.getFullURL(for: APIConfig.loginPath)
        let parameters: [String: String] = [
            "phoneNumber": phoneNumber,
            "password": password
        ]
        
        AF.request(url, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: ResponseModel<UserData>.self) { response in
                switch response.result {
                case .success(let userResponse):
                    if userResponse.code == .success {
                        let userName = userResponse.data?.fullName ?? "User"
                        completion(.success("Login successful! Welcome, \(userName)"))
                    } else {
                        completion(.failure(NSError(domain: userResponse.msg, code: userResponse.code.rawValue)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
}
