//
//  DBObserver.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 20/11/2021.
//

import RxSwift

final class DBObserver:NSObject{
    enum DBObserverType{
        case update
        case add
        case category
    }
    var disposeBag = DisposeBag()
    public let didUpdateDB = PublishSubject<(Date)>()
    public let didAddNewItem = PublishSubject<(Date)>()
    public let didUpdateCategory = PublishSubject<Void>()
    private let didUpdateDBNotification = Notification.Name(rawValue: "didUpdateDBNotification")

    override init(){
        super.init()
        self.observe()
    }
    func observe() {
        NotificationCenter.default.rx.notification(didUpdateDBNotification)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] notification in
                self?.didUpdate(notification: notification)
            }
            .disposed(by: disposeBag)
    }
    @objc func didUpdate(notification: Notification) {

        guard let type = notification.userInfo?["type"] as? DBObserverType else {
            return
        }
        switch type {
        case .update:
            guard let date = notification.userInfo?["date"] as? Date else {
                return
            }
            didUpdateDB.onNext(date)
        case .add:
            guard let date = notification.userInfo?["date"] as? Date else {
                return
            }
            didAddNewItem.onNext(date)
        case .category:
            didUpdateCategory.onNext(())
        }
        
    }
    func update(date: Date) {
        let userInfo: [String: Any] = ["date": date,
                                       "type":DBObserverType.update]
        NotificationCenter.default.post(Notification.init(name: didUpdateDBNotification, object: nil, userInfo: userInfo))
    }
    func add(date: Date) {
        let userInfo: [String: Any] = ["date": date,
                                       "type":DBObserverType.add]
        NotificationCenter.default.post(Notification.init(name: didUpdateDBNotification, object: nil, userInfo: userInfo))
    }
    func updateCategory() {
        let userInfo: [String: Any] = ["type":DBObserverType.category]
        NotificationCenter.default.post(Notification.init(name: didUpdateDBNotification, object: nil, userInfo: userInfo))
    }
    deinit {
        #if DEBUG
        print("Deinit:\(self.className)")
        #endif
    }
}
