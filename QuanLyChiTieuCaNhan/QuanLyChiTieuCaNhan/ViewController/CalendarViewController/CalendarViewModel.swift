//
//  CalendarViewModel.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 12/11/2021.
//

import RxSwift
import RxCocoa
import Action
class CalendarViewModel: BaseViewModel,BaseViewModelProtocol {
    lazy var observe = {
        return DBObserver()
    }()
    struct Input {
        let dateSelected: Observable<Date>
    }
    struct Output {
        let arrayHistory: Driver<[ItemModel]>
        let totalSpend: Driver<String>
        let totalIncome: Driver<String>
        let total: Driver<String>
    }
    func transfrom(from input: Input) -> Output {
        let arrayHistory = PublishSubject<[ItemModel]>()
        let totalSpend = PublishSubject<String>()
        let totalIncome = PublishSubject<String>()
        let total = PublishSubject<String>()
        var dateSelected = Date()
        let realmManager = RealmDataManager.shared
        
        let getItemByDateAction: Action<Date,[ItemModel]> = Action {date in
            return Observable.just(realmManager.getItemsByDay(date: date))
        }
        let getTotalByMonthAction: Action<(Date),(Int,Int)> = Action {month in
            return Observable.just(realmManager.getTotalByPeriod(time: month, period: .month))
        }

        input.dateSelected.subscribe(onNext: {date in
            dateSelected = date
            getItemByDateAction.execute(date)
            getTotalByMonthAction.execute(date)
        }).disposed(by: disposeBag)

        getItemByDateAction.elements.subscribe(onNext: {items in
            arrayHistory.onNext(items)
        }).disposed(by: disposeBag)
        
        getTotalByMonthAction.elements.subscribe(onNext: { spend, income in
            totalIncome.onNext(income.formatCurrency())
            totalSpend.onNext(spend.formatCurrency())
            total.onNext((income-spend).formatCurrency())
        }).disposed(by: disposeBag)
        observe.didUpdateDB.subscribe(onNext: {date in
            getItemByDateAction.execute(date)
            getTotalByMonthAction.execute(date)
        }).disposed(by: disposeBag)
        observe.didAddNewItem.subscribe(onNext: {date in
            if date.stringWith(format: "dd/MM/yyyy") == dateSelected.stringWith(format: "dd/MM/yyyy") {
                getItemByDateAction.execute(date)
                getTotalByMonthAction.execute(date)
            }
        }).disposed(by: disposeBag)
        return Output(arrayHistory: arrayHistory.asDriver(onErrorJustReturn: []),
                      totalSpend: totalSpend.asDriver(onErrorJustReturn: ""),
                      totalIncome: totalIncome.asDriver(onErrorJustReturn: ""),
                      total: total.asDriver(onErrorJustReturn: ""))
    }
}
