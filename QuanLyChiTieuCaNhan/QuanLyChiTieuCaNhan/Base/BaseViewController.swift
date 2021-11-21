//
//  BaseViewController.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 11/11/3 Reiwa.
//

import UIKit
import RxSwift
import RxCocoa

protocol BaseViewControllerProtocol: AnyObject {
    associatedtype ViewModelType: BaseViewModelProtocol
    var viewModel: ViewModelType! { get set }
    
    init(viewModel:ViewModelType)
    func setupViews()
    func bindingViewModels()
    func setupRx()
}


extension BaseViewControllerProtocol where Self: UIViewController {
    static func instantiate<ViewModelType> (withViewModel viewModel: ViewModelType) -> Self where ViewModelType == Self.ViewModelType {
        let viewController = Self.init()
        viewController.viewModel = viewModel
        return viewController
    }
}

class BaseViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var disposeBag = DisposeBag()
    var interactivePopGestureRecognizer = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        overrideUserInterfaceStyle = .light
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        if !(self.tabBarController?.tabBar.isHidden ?? false){
    //            let bottomPadding = self.view.window?.safeAreaInsets.bottom ?? 0
    //            if bottomPadding == 0 {
    //                self.additionalSafeAreaInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: (TABBAR_HEIGHT  + 4) - (self.tabBarController?.tabBar.frame.size.height ?? 50), right: 0)
    //            }else{
    //                self.additionalSafeAreaInsets = UIEdgeInsets.init(top: TABBAR_HEIGHT - (self.tabBarController?.tabBar.frame.size.height ?? 50), left: 0, bottom: 0, right: 0)
    //            }
    //        }else{
    ////            self.additionalSafeAreaInsets = .zero
    //        }
    //        self.view.layoutIfNeeded()
    //    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let tabbarVC = self.tabBarController as? TabbarViewController else{
            return
        }
        if !(tabbarVC.tabBar.isHidden){
            let bottomPadding = self.view.window?.safeAreaInsets.bottom ?? 0
            if bottomPadding == 0 {
                tabbarVC.additionalSafeAreaInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: (tabbarVC.TABBAR_HEIGHT  + 4) - (tabbarVC.DEFAULT_TABBAR_HEIGHT), right: 0)
            }else{
                self.tabBarController?.additionalSafeAreaInsets = UIEdgeInsets.init(top: tabbarVC.TABBAR_HEIGHT - (tabbarVC.DEFAULT_TABBAR_HEIGHT), left: 0, bottom: 0, right: 0)
            }
        }else{
            self.tabBarController?.additionalSafeAreaInsets = .zero
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            return interactivePopGestureRecognizer
        }
        return true
    }
    
    deinit {
#if DEBUG
        print("Deinit:\(self.className)")
#endif
    }
}
