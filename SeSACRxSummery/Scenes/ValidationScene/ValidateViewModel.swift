//
//  ValidateViewModel.swift
//  SeSACRxSummery
//
//  Created by Taekwon Lee on 2023/11/07.
//

import Foundation

import RxSwift
import RxCocoa

///DATE: 231107
class ValidateViewModel {

    let validText = BehaviorRelay(value: "닉네임은 8자 이상입니다")
    
    struct Input {
        let text: ControlProperty<String?> // nameTextField.rx.text
        let tap: ControlEvent<Void> // nextButton.rx.tap
    }
    
    struct Output {
        let text: Driver<String>
        let tap: ControlProperty<Void>
        let validation: Observable<Bool>
    }
}

/*:
 ### 📌 Driver 이유?
 let text: Driver<String>
 
 
 `func asDriver() -> Driver<String>`
 
 viewModel.validText
     .asDriver()
 
 반환형 ->
 
 
 ### 📌 validation
 `let validation: Observable<Bool>`
 */
