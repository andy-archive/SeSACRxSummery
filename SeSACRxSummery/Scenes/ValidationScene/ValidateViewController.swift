//
//  ValidateViewController.swift
//  SeSACRxSummery
//
//  Created by Taekwon Lee on 2023/11/07.
//

import UIKit

import RxSwift
import RxCocoa

final class ValidateViewController: UIViewController {
    
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var validationLabel: UILabel!
    @IBOutlet private var nextButton: UIButton!
    
    private let viewModel = ValidateViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let validText = BehaviorRelay(value: "닉네임은 8자 이상입니다")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    ///DATE: 231107
    private func bind() {
        viewModel.validText
            .asDriver()
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        // UITextField에 8글자 이상 시
        // UILabel 숨기고 UIButton 활성화
        
        ///MARK: JACK
        let validation = nameTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
        
        validation
            .bind(to: nextButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemRed : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                print("nextButton CLICKED")
            }
            .disposed(by: disposeBag)
    }
    

}

/*
 // UITextField에 8글자 이상 시
 // UILabel 숨기고 UIButton 활성화
 
 ///MARK: ANDY
 
 private var isButtonEnabled = BehaviorSubject(value: false)
 private var isLabelHidden = BehaviorSubject(value: false)
 
 private func bind() {
     viewModel.validText
         .asDriver()
         .drive(validationLabel.rx.text)
         .disposed(by: disposeBag)
     
     nameTextField.rx.text.orEmpty
         .subscribe(with: self) { owner, value in
             let data = validText.value.count
             validText.bind(onNext: data)
         }
         .disposed(by: disposeBag)
     
     isButtonEnabled
         .bind(to: nextButton.rx.isEnabled)
         .disposed(by: disposeBag)
     
     isLabelHidden
         .bind(to: validationLabel.rx.isHidden)
         .disposed(by: disposeBag)
 }
 */
