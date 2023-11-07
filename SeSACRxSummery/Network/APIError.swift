//
//  APIError.swift
//  SeSACRxSummery
//
//  Created by Taekwon Lee on 2023/11/07.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}
