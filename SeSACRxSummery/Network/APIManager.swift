//
//  APIManager.swift
//  SeSACRxSummery
//
//  Created by Taekwon Lee on 2023/11/09.
//

import Foundation
import Moya

class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    private let provider = MoyaProvider<SesacAPI>()
    
    func signUp(email: String, password: String, nick: String) {
        
        let data = SignupRequest(
            email: email,
            password: password,
            nick: nick
        )
        
        provider.request(
            .signUp(model: SignupRequest(
                email: email,
                password: password,
                nick: nick))) { result in
                    
            switch result {
            case .success(let value):
                print("SUCCESS", value.statusCode, value.data)
                
                do {
                    let value = try JSONDecoder().decode(SignupResponse.self, from: value.data)
                } catch {
                    print("DECODE ERROR")
                }
                
            case .failure(let error):
                print("ERROR", error.localizedDescription)
            }
        }
    }
}
