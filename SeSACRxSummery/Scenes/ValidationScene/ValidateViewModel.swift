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

    // 받아온 데이터
    struct Input {
        let text: ControlProperty<String?> // nameTextField.rx.text
        let tap: ControlEvent<Void> // nextButton.rx.tap
    }
    
    // 가공한 데이터
    struct Output {
        let text: Driver<String>
        let tap: ControlEvent<Void>
        let validation: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let validation = input.text
            .orEmpty
            .map { $0.count >= 8 }
        
        let validText = BehaviorRelay(value: "닉네임은 8자 이상입니다")
            .asDriver()
        
        return Output(
            text: validText,
            tap: input.tap,
            validation: validation
        )
    }
}

/*
 //Driver를  사용하지 않는다면?
 struct Output {
    let text: Observable<String>
 }
 
 func transform(input: Input) -> Output {
    let validText = Observable.of("닉네임은 8자 이상입니다")
 }
 */

/*
 📌 in ValidateViewController
 
 let input = ValidateViewModel.Input(text: nameTextField.rx.text, tap: nextButton.rx.tap)
 
 let validation = nameTextField.rx.text.orEmpty
     .map { $0.count >= 8 }
 */

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
