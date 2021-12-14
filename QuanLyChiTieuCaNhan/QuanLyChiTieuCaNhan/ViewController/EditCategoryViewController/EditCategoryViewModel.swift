//
//  EditCategoryViewModel.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 21/11/2021.
//

import RxSwift
import RxCocoa
import Action
import Foundation
import CloudKit
import SwiftUI

class EditCategoryViewModel: BaseViewModel, BaseViewModelProtocol {
    let type: Int
    init(type: ItemType) {
        self.type = type.rawValue
    }
    lazy var observe = {
        return DBObserver()
    }()
    struct Input {
        let onAppear: Observable<Void>
        let deleteTrigger: Observable<CategoryModel>
        let newCategory: Observable<String>
        let typeTrigger: Observable<Int>
        let addTrigger: Observable<Void>
    }
    struct Output {
        let allCategories: Driver<[CategoryModel]>
        let addSuccess: Driver<Bool>
        let newCategory: Driver<CategoryModel>
    }
    func transfrom(from input: Input) -> Output {
        let allCategories = PublishSubject<[CategoryModel]>()
        let addSuccess = PublishSubject<Bool>()
        let newCategory = PublishSubject<CategoryModel>()
        let realmManager = RealmDataManager.shared
        let temp = BehaviorRelay<[CategoryModel]>(value: [])
        
        let getCategory: Action<(Int),[CategoryModel]> = Action {type in
            return Observable.just(realmManager.getCategory(type: ItemType(rawValue: type)!))
        }
        input.onAppear.withLatestFrom(Observable.just(self.type)).bind(to: getCategory.inputs).disposed(by: disposeBag)
        getCategory.elements.subscribe(onNext: {all in
            temp.accept(all)
            allCategories.onNext([CategoryModel(type: ItemType(rawValue: 0)!, title: "Thêm danh mục ...")] + all)
        }).disposed(by: disposeBag)
        input.typeTrigger.bind(to: getCategory.inputs).disposed(by: disposeBag)
        
        let deleteAction: Action<(CategoryModel),Bool> = Action {item in
            var value = temp.value
            value.removeAll(where: {$0 == item})
            temp.accept(value)
            return Observable.just(realmManager.delete(object: item))
        }
        input.deleteTrigger.bind(to: deleteAction.inputs).disposed(by: disposeBag)
        deleteAction.elements.subscribe(onNext: {[weak self] success in
            self?.observe.updateCategory()
        }).disposed(by: disposeBag)
        
        let addAction: Action<(Int,String), CategoryModel?> = Action {type, tittle in
            guard let object = realmManager.addObject(object: CategoryModel(type: ItemType(rawValue: type)!, title: tittle)) as? CategoryModel else {
                return Observable.just(nil)
            }
            return Observable.just(object)
        }
        let observe = Observable.combineLatest(input.typeTrigger, input.newCategory)
        input.addTrigger
            .withLatestFrom(observe)
            .map { (_, title) -> Bool in
                if title.isEmpty {
                    addSuccess.onNext(false)
                    return false
                }
                if temp.value.contains(where: {$0.title.lowercased() == title.lowercased()}) {
                    addSuccess.onNext(false)
                    return false
                }
                return true
            }
            .filter{$0}
            .withLatestFrom(observe)
            .bind(to: addAction.inputs)
            .disposed(by: disposeBag)
        addAction.elements.subscribe(onNext: {[weak self] category in
            guard let category = category else {
                addSuccess.onNext(false)
                return
            }
            temp.accept(temp.value + [category])
            self?.observe.updateCategory()
            newCategory.onNext(category)
        }).disposed(by: disposeBag)
        return Output(allCategories: allCategories.asDriver(onErrorJustReturn: []),
                      addSuccess: addSuccess.asDriver(onErrorJustReturn: false),
                      newCategory: newCategory.asDriver(onErrorJustReturn: CategoryModel(type: .spend, title: "")))
    }
}
