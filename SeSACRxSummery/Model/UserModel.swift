//
//  UserModel.swift
//  SeSACRxSummery
//
//  Created by Taekwon Lee on 2023/11/09.
//

import Foundation

//231109
// 회원가입, 로그인 구조체 생성
// Moya - requestJSONEncodable을 위한 구조체
struct SignupRequest: Encodable {
    let email: String
    let password: String
    let nick: String
}

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct SignupResponse: Decodable {
    let email: String
    let nick: String
}

struct withdrawResponse: Decodable {
    let email: String
    let nick: String
}
