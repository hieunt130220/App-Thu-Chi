//
//  Validate.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 25/04/2022.
//

import Foundation
class Validators {
    static func validatePassword(password:String?, label:String? = nil)->(result:Bool, errorMessage:String?) {
        let passwordRegex =  "[A-Za-z\\d@$!%*#?&^_-]+"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        if password?.isEmpty ?? true {
            return (false, "Vui lòng nhập mật khẩu")
        }
        if password!.count < 8 || password!.count > 16 {
            return (false, "Nhập mật khẩu từ 8->16 kí tự")
        } else if passwordCheck.evaluate(with: password) == false {
            return (false, "有効なパスワードアドレスを指定してください")
        }
        return (true, nil)
    }
    static func validateEmail(email: String?, label: String? = nil)->(result: Bool, errorMessage: String?) {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailCheck = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if email == nil || email == "" {
            return (false, "Vui lòng nhập email")
        }
        if emailCheck.evaluate(with: email) == false {
            return (false, "Email không đúng định dạng")
        }
        return (true, nil)
    }
    
    static func validateNewPassword(newPassword: String?, oldPassword: String?, newPassLabel: String? = nil, oldPassLabel: String? = nil)->(result: Bool, errorMessage: String?) {
        let (result, errorMessage) = validatePassword(password: newPassword, label: "\(newPassLabel ?? "")")
        if !result {
            return (false, errorMessage)
        }
        if newPassword == oldPassword, oldPassword != nil {
            return (false, "新しいパスワードは古いパスワードとは異なる必要があります")
        }
        return (true, nil)
    }
    
    static func validateConfirmPassword(password: String?, confirmPassword: String?, confirmPassLabel: String? = nil, newPassLabel: String? = nil)->(result: Bool, errorMessage: String?) {
        if !validatePassword(password: password).result || !validatePassword(password: confirmPassword).result {
            return (false, nil)
        }
        if confirmPassword != password {
            return (false, "Mật khẩu không khớp")
        }
        return (true, nil)
    }
}
