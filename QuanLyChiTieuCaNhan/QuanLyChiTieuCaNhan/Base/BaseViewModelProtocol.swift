//
//  BaseViewModelProtocol.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 11/11/3 Reiwa.
//

import UIKit
import RxSwift

//MARK: - BaseViewModelProtocol
protocol BaseViewModelProtocol: AnyObject {
    
    associatedtype Input
    associatedtype Output
    
    func transfrom(from input: Input) -> Output
}

//MARK: - BaseViewModel
class BaseViewModel:NSObject{
    var disposeBag = DisposeBag()
    deinit {
        #if DEBUG
        print("Deinit:\(self.className)")
        #endif
    }
}
