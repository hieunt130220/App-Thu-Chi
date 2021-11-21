//
//  DetailReportViewModel.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 21/11/2021.
//

import RxSwift
import RxCocoa
import Action
import Foundation
import CloudKit
class DetailReportViewModel: BaseViewModel, BaseViewModelProtocol {
    let category: String
    let time: Date
    init(category: String, time: Date) {
        self.category = category
        self.time = time
    }
    struct Input {
        let onApear: Observable<Void>
    }
    struct Output {
        let totalArray: Driver<[Int]>
    }
    func transfrom(from input: Input) -> Output {
        let totalArray = PublishSubject<[Int]>()
        let realmManager = RealmDataManager.shared
        
        let fetchAction: Action<(),[Int]> = Action {[weak self] _ in
            return Observable.just(realmManager.getTotalCategoryByMonth(category: self!.category, date: self!.time))
        }
        input.onApear
            .bind(to: fetchAction.inputs)
            .disposed(by: disposeBag)
        
        fetchAction.elements.subscribe(onNext: {array in
            totalArray.onNext(array)
        }).disposed(by: disposeBag)

        return Output(totalArray: totalArray.asDriver(onErrorJustReturn: []))
    }
}
