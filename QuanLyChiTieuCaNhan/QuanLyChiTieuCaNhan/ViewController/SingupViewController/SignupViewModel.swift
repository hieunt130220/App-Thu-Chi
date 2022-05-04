//
//  SignupViewModel.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 25/04/2022.
//

import RxSwift
import RxCocoa
import Action
import FirebaseAuth
class SignupViewModel: BaseViewModel, BaseViewModelProtocol {
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let confirmPassword: Observable<String>
        let signupTrigger: Observable<Void>
    }
    struct Output {
        let errorString: Driver<String>
        let enableButton: Driver<Bool>
        let isSuccess: Driver<Bool>
    }
    func transfrom(from input: Input) -> Output {
        let errorString = PublishSubject<String>()
        let enableButton = PublishSubject<Bool>()
        let isSuccess = PublishSubject<Bool>()
        
        Observable.combineLatest(input.email, input.password, input.confirmPassword)
            .map { (email, password, confirmPassword) -> Bool in
                return !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
            }.bind(to: enableButton).disposed(by: disposeBag)
        let observe = Observable.combineLatest(input.email, input.password, input.confirmPassword)
        input.signupTrigger
            .withLatestFrom(observe)
            .do(onNext: {email, password, confirmPassword in
                let validateEmail = Validators.validateEmail(email: email)
                let validatePassword = Validators.validatePassword(password: password)
                let validateRePassword = Validators.validatePassword(password: confirmPassword)
                let validateConfirmPassword = Validators.validateConfirmPassword(password: password, confirmPassword: confirmPassword)
                if !validateEmail.result {
                    errorString.onNext(validateEmail.errorMessage!)
                    return
                }
                if !validatePassword.result {
                    errorString.onNext(validatePassword.errorMessage!)
                    return
                }
                if !validateRePassword.result {
                    errorString.onNext(validateRePassword.errorMessage!)
                    return
                }
                if !validateConfirmPassword.result {
                    errorString.onNext(validateConfirmPassword.errorMessage!)
                    return
                }
                errorString.onNext("")
            })
            .withLatestFrom(errorString)
            .filter {$0.isEmpty}
            .withLatestFrom(observe)
            .subscribe(onNext: {email, password, _ in
                AuthRepository.signup(email: email, password: password) { bool in
                    isSuccess.onNext(bool)
                } failture: { msg in
                    errorString.onNext(msg)
                }
            })
            .disposed(by: disposeBag)
        
        return Output.init(errorString: errorString.asDriver(onErrorJustReturn: ""),
                           enableButton: enableButton.asDriver(onErrorJustReturn: false),
                           isSuccess: isSuccess.asDriver(onErrorJustReturn: false))
    }
}
