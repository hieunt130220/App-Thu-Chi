//
//  DetailViewModel.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 20/11/2021.
//

import RxSwift
import RxCocoa
import Action
import Foundation
class EditViewModel: BaseViewModel, BaseViewModelProtocol {
    lazy var observe = {
        return DBObserver()
    }()
    let item: ItemModel
    let date: Date
    init(item: ItemModel) {
        self.item = item
        self.date = Date.dateFromString(dateString: item.date, format: "dd/MM/yyyy") ?? Date()
    }
    struct Input {
        let onAppear: Observable<Void>
        let deleteTrigger: Observable<Void>
        let editTrigger: Observable<Void>
        let amount: Observable<String>
        let note: Observable<String>
    }
    struct Output {
        let deleteSuccess: Driver<Bool>
        let editSuccess: Driver<Bool>
        let enableButton: Driver<Bool>
        let item: Driver<ItemModel>
    }
    func transfrom(from input: Input) -> Output {
        let deleteSuccess = PublishSubject<Bool>()
        let editSuccess = PublishSubject<Bool>()
        let enableButton = PublishSubject<Bool>()
        let item = PublishSubject<ItemModel>()
        let dataManager = RealmDataManager.shared
        
        let deleteAction: Action<(),Bool> = Action {[weak self] in
            return Observable.just(dataManager.delete(object: self!.item))
        }
        input.deleteTrigger.bind(to: deleteAction.inputs).disposed(by: disposeBag)
        deleteAction.elements.subscribe(onNext: {[weak self] success in
            self?.observe.update(date: self!.date)
            deleteSuccess.onNext(success)
        }).disposed(by: disposeBag)
        
        input.onAppear
            .subscribe(onNext: {[weak self] in
                item.onNext(self!.item)
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(input.note, input.amount)
            .map{[weak self] note, amount in
                return (Int(amount) != self!.item.amount && !amount.isEmpty && Int(amount) != 0) || note != self!.item.note
            }
            .bind(to: enableButton)
            .disposed(by: disposeBag)
        input.editTrigger
            .withLatestFrom(Observable.combineLatest(input.note,input.amount))
            .subscribe(onNext: {[weak self] note, amount in
                let item = dataManager.realm.objects(ItemModel.self).filter("date = %@ AND category = %@", self!.item.date, self!.item.category)
                if let item = item.first {
                    try! dataManager.realm.write {
                        item.note = note
                        item.amount = Int(amount) ?? 0
                        editSuccess.onNext(true)
                        self?.observe.update(date: self!.date)
                    }
                }
            })
            .disposed(by: disposeBag)
        return Output(deleteSuccess: deleteSuccess.asDriver(onErrorJustReturn: false),
                      editSuccess: editSuccess.asDriver(onErrorJustReturn: false),
                      enableButton: enableButton.asDriver(onErrorJustReturn: false),
                      item: item.asDriver(onErrorJustReturn: ItemModel()))
    }
}
