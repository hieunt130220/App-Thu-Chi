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
    }
    var disposeBag = DisposeBag()
    public let didUpdateDB = PublishSubject<(Date)>()
    public let didAddNewItem = PublishSubject<(Date)>()
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
        guard let date = notification.userInfo?["date"] as? Date else {
            return
        }
        guard let type = notification.userInfo?["type"] as? DBObserverType else {
            return
        }
        switch type {
        case .update:
            didUpdateDB.onNext(date)
        case .add:
            didAddNewItem.onNext(date)
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
    deinit {
        #if DEBUG
        print("Deinit:\(self.className)")
        #endif
    }
}
