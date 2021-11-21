//
//  ReportViewModel.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 14/11/2021.
//

import Foundation
import RxSwift
import RxCocoa
import CloudKit
import Action
class ReportViewModel: BaseViewModel, BaseViewModelProtocol {
    struct Input {
        let dateTrigger: Observable<Date>
        let typeTrigger: Observable<Int>
        let periodTrigger: Observable<Int>
    }
    struct Output {
        let allData: Driver<[[String:Any]]>
        let totalSpend: Driver<Int>
        let totalIncome: Driver<Int>
        let total: Driver<Int>
        let dataChart: Driver<[[String:Any]]>
    }
    func transfrom(from input: Input) -> Output {
        let allData = PublishSubject<[[String:Any]]>()
        let totalSpend = PublishSubject<Int>()
        let totalIncome = PublishSubject<Int>()
        let total = PublishSubject<Int>()
        let dataChart = PublishSubject<[[String:Any]]>()
        let realmManager = RealmDataManager.shared
        
        let getAllDataAction: Action<(Date,ItemType,Int),[[String:Any]]> = Action {time,type, period in
            if period == 0 {
                return Observable.just(realmManager.getListItemByPeriod(time: time, type: type, period: .month))
            } else {
                return Observable.just(realmManager.getListItemByPeriod(time: time, type: type, period: .year))
            }
        }
        Observable.combineLatest(input.dateTrigger, input.typeTrigger, input.periodTrigger)
            .map{date, type, period in
                return (date, type == ItemType.income.rawValue ? ItemType.income : ItemType.spend, period )
            }
            .bind(to: getAllDataAction.inputs)
            .disposed(by: disposeBag)
        
        getAllDataAction.elements.subscribe(onNext: {resultValue in
            allData.onNext(resultValue)
        }).disposed(by: disposeBag)
        let getTotalAction: Action<(Date,Int),(Int,Int)> = Action {time, period in
            if period == 0 {
                return Observable.just(realmManager.getTotalByPeriod(time: time, period: .month))
            } else {
                return Observable.just(realmManager.getTotalByPeriod(time: time, period: .year))
            }
        }
        Observable.combineLatest(input.dateTrigger,input.periodTrigger)
            .bind(to: getTotalAction.inputs)
            .disposed(by: disposeBag)
        getTotalAction.elements.subscribe(onNext: {spend, income in
            totalIncome.onNext(income)
            totalSpend.onNext(spend)
            total.onNext((income-spend))
        }).disposed(by: disposeBag)
                
        Observable.combineLatest(allData,totalIncome,totalSpend,input.typeTrigger)
            .subscribe(onNext: {result, income, spend, type in
                var tmp:[[String:Any]] = []
                if type == 0 {
                    for item in result {
                        tmp.append(["\(item.keys.first ?? "")" : CGFloat(item.values.first as! Int) / CGFloat(spend)])
                    }
                } else {
                    for item in result {
                        tmp.append(["\(item.keys.first ?? "")" : CGFloat(item.values.first as! Int) / CGFloat(income)])
                    }
                }
                dataChart.onNext(tmp)
            }).disposed(by: disposeBag)
        return Output(allData: allData.asDriver(onErrorJustReturn: []),
                      totalSpend: totalSpend.asDriver(onErrorJustReturn: 0),
                      totalIncome: totalIncome.asDriver(onErrorJustReturn: 0),
                      total: total.asDriver(onErrorJustReturn: 0),
                      dataChart:dataChart.asDriver(onErrorJustReturn: []))
    }
}
