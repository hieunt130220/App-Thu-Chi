//
//  UIViewController+ext.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 12/11/2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
extension UIViewController {
    func showAlert(message: String, callback: @escaping (()->())) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Xong", style: .cancel, handler: {_ in 
            callback()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func showConfirm(message: String, callback: @escaping (()->())) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Huỷ", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .cancel, handler: {_ in
            callback()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
public extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Void> {
    
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source)
    }
}
