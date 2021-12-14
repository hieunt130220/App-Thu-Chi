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
class DetailReportViewModel: BaseViewModel, BaseViewModelProtocol {
    let category: String
    let time: Date
    init(category: String, time: Date) {
        self.category = category
        self.time = time
    }
    struct Input {
        let onApear: Observable<Void>
        let monthSelected: Observable<Int>
    }
    struct Output {
        let totalArray: Driver<[Int]>
        let itemArray: Driver<[ItemModel]>
    }
    func transfrom(from input: Input) -> Output {
        let totalArray = PublishSubject<[Int]>()
        let itemArray = PublishSubject<[ItemModel]>()
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
        let getItemByMonthAction: Action<Date, [ItemModel]> = Action {[weak self] month in
            return Observable.just(realmManager.getItemByCategory(category: self!.category, time: month))
        }
        input.monthSelected
            .map{[weak self] monthInt -> Date in
                return Date.dateFromComponents(year: self!.time.year , month: monthInt, day: self!.time.day) ?? Date()
            }
            .subscribe(onNext: {month in
                getItemByMonthAction.execute(month)
            }).disposed(by: disposeBag)
        getItemByMonthAction.elements.subscribe(onNext: {items in
            itemArray.onNext(items)
        }).disposed(by: disposeBag)
        return Output(totalArray: totalArray.asDriver(onErrorJustReturn: []),
                      itemArray: itemArray.asDriver(onErrorJustReturn: []))
    }
}
