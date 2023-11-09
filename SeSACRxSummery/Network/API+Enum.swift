//
//  API+Enum.swift
//  SeSACRxSummery
//
//  Created by Taekwon Lee on 2023/11/09.
//

import Foundation
import Moya

//231109 Moya 연습
enum SesacAPI {
    case signUp(model: SignupRequest)
    case login(email: String, password: String)
    case withdraw
}

extension SesacAPI: TargetType {
    var baseURL: URL {
        URL(string: "\(APIKey.slpURL)")!
    }
    
    var path: String {
        switch self {
        case .signUp: return "join"
        case .login: return "login"
        case .withdraw: return "withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .login: return .post
        case .withdraw: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp(let data):
            return .requestJSONEncodable(data)
        case .login(let email, let password):
            let data = LoginRequest(email: email, password: password)
            return .requestJSONEncodable(data)
        case .withdraw:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "SesacKey": "\(APIKey.slpKey)"
        ]
    }
}

// 231109
// requestJSONEncodable을 위한 구조체
struct emailRequestModel: Encodable {
    let email: String
    let password: String
}

/* WARNING: JSON이 아님
 var task: Moya.Task {
     return .requestParameters(
         parameters: [
             "id": "",
             "pw": ""
         ],
         encoding: URLEncoding.httpBody
     )
 }
 */
