//
//  APIConfig.swift
//  Gogo
//
//  Created by Xian Yin on 12/28/24.
//

struct APIConfig {
    // 环境类型
        enum Environment {
            case development
            case production
        }

        // 当前环境
        static var currentEnvironment: Environment = .development

        // Base URL 根据环境动态切换
        static var baseURL: String {
            switch currentEnvironment {
            case .development:
                return "http://192.168.1.158:8080" // 开发服务器地址
            case .production:
                return "https://api.productionserver.com" // 生产服务器地址
            }
        }

        // 用户
        static let loginPath: String = "/api/users/login"
        static let registerPath: String = "/api/users/register"
        static let findUserByPhoneNumber: String = "/api/users/userByPhone"
    
        //验证
        static let sendCode: String = "/api/verification/sendCode"
        static let verifyCode: String = "/api/verification/verifyCode"

        // 构建完整 URL
        static func getFullURL(for path: String) -> String {
            return "\(baseURL)\(path)"
        }
}
