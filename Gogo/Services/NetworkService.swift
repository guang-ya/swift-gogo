//
//  NetworkService.swift
//  Gogo
//
//  Created by Xian Yin on 12/26/24.
//

import Foundation
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    // 发送验证码请求
    func sendVerificationCode(phoneNumber: String, country: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = APIConfig.getFullURL(for: APIConfig.sendCode)
        let parameters: [String: String] = [
            "phoneNumber": phoneNumber,
            "country": country
        ]
        
        AF.request(url, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: ResponseModel<String>.self) { response in
                switch response.result {
                case .success(let result):
                    if result.code == .success { // 假设 `ResponseEnum.success` 为 200
                        completion(.success("Verification code sent successfully"))
                    } else {
                        completion(.failure(NSError(domain: result.msg, code: result.code.rawValue, userInfo: nil)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func verifyOTP(phoneNumber: String, country: String, code: String, completion: @escaping (Result<String, Error>) -> Void) {
            let url = APIConfig.getFullURL(for: APIConfig.verifyCode)
            let parameters: [String: String] = [
                "phoneNumber": phoneNumber,
                "country": country,
                "code": code
            ]
            
            AF.request(url, method: .post, parameters: parameters)
                .validate()
                .responseDecodable(of: ResponseModel<String>.self) { response in
                    switch response.result {
                    case .success(let result):
                        if result.code == .success { // 假设成功的 code 是 200
                            completion(.success("Verification successful"))
                        } else {
                            completion(.failure(NSError(domain: result.msg, code: result.code.rawValue, userInfo: nil)))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
    
    func completeProfile(username: String, email: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "https://api.yourbackend.com/completeProfile"
        let parameters: [String: Any] = [
            "username": username,
            "email": email
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Profile completion success: \(value)")
                    completion(.success("Profile completion success"))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
