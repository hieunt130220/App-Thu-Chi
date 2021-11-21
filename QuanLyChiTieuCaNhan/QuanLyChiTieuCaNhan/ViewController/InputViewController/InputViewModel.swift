//
//  InputViewModel.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 12/11/2021.
//

import RxSwift
import RxCocoa
class InputViewModel: BaseViewModel,BaseViewModelProtocol {
    lazy var observe = {
        return DBObserver()
    }()
    struct Input {
        let type: Observable<Int>
        let date: Observable<Date>
        let note: Observable<String>
        let category: Observable<String>
        let amount: Observable<String>
        let doneTrigger: Observable<Void>
    }
    struct Output {
        let categories: Driver<[CategoryModel]>
        let addSuccess: Driver<Bool>
        let currentTab: Driver<ItemType>
        let enableButton: Driver<Bool>
    }
    func transfrom(from input: Input) -> Output {
        let categories = BehaviorSubject<[CategoryModel]>(value: [])
        let addSuccess = PublishSubject<Bool>()
        let realmManager = RealmDataManager.shared
        let currentTab = PublishSubject<ItemType>()
        
        input.type
            .subscribe(onNext: {index in
                if index == ItemType.income.rawValue {
                    currentTab.onNext(.income)
                    categories.onNext(CategoryModel.dummyData(type: .income))
                } else {
                    currentTab.onNext(.spend)
                    categories.onNext(CategoryModel.dummyData(type: .spend))
                }
            }).disposed(by: disposeBag)
        let observe = Observable.combineLatest(input.date, input.type, input.amount, input.category, input.note)
        input.doneTrigger
            .withLatestFrom(observe)
            .subscribe(onNext: {[weak self] date,type,amount,category,note in
                let item = realmManager.realm.objects(ItemModel.self).filter("date = %@ AND category = %@", date.stringWith(format: "dd/MM/yyyy"), category)
                if let item = item.first {
                    try! realmManager.realm.write {
                        item.note = note
                        item.amount = item.amount + Int(amount)!
                    }
                }  else {
                    let object = ItemModel(type: type == ItemType.income.rawValue ? .income : .spend, date: date.stringWith(format: "dd/MM/yyyy"), note: note, category: category, amount: Int(amount) ?? 0)
                    realmManager.addObject(object: object)
                }
                addSuccess.onNext(true)
                self?.observe.add(date: date)
            }).disposed(by: disposeBag)
        
        let enableButon = Observable.combineLatest(input.amount.map{Int($0) != 0 && !$0.isEmpty},
                                                   input.category.map{!$0.isEmpty})
            .map{$0 && $1}
        
        return Output.init(categories: categories.asDriver(onErrorJustReturn: []),
                           addSuccess: addSuccess.asDriver(onErrorJustReturn: false),
                           currentTab: currentTab.asDriver(onErrorJustReturn: .income),
                           enableButton: enableButon.asDriver(onErrorJustReturn: false))
    }
}
