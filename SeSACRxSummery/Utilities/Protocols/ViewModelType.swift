//
//  ViewModelType.swift
//  SeSACRxSummery
//
//  Created by Taekwon Lee on 2023/11/08.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
/* ViewModelType 프로토콜 채택 시
 
final class TestViewModel: ViewModelType {
    typealias Input = <#type#>
    
    typealias Output = <#type#>
}
*/
