//
//  AuthRepository.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 25/04/2022.
//

import Foundation
import FirebaseAuth
import RxSwift
class AuthRepository: NSObject {
    static func signup(email: String, password: String, success: @escaping (Bool)->Void, failture: @escaping (String)->Void) {
        APP_DELEGATE.topWindow?.activityIndicatorView.rx.isAnimating.onNext(true)
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            APP_DELEGATE.topWindow?.activityIndicatorView.rx.isAnimating.onNext(false)
            if let error = error {
                print(error.localizedDescription)
                failture("Email đã tồn tại")
                return
            }
            guard let userId = result?.user.uid else {
                failture("Email không thể đăng kí")
                return
            }
            Settings.shared.userId = userId
            success(true)
        }
    }
    static func login(email: String, password: String, success: @escaping (Bool)->Void, failture: @escaping (String)->Void) {
        APP_DELEGATE.topWindow?.activityIndicatorView.rx.isAnimating.onNext(true)
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            APP_DELEGATE.topWindow?.activityIndicatorView.rx.isAnimating.onNext(false)
            if let error = error {
                print(error.localizedDescription)
                failture("Email hoặc mật khẩu không đúng")
                return
            }
            guard let userId = result?.user.uid else {
                failture("Tài khoản không tồn tại")
                return
            }
            Settings.shared.userId = userId
            success(true)
        }
    }
}
