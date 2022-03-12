//
//  TabbarViewController.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 11/11/2021.
//

import Foundation
import UIKit
import RxSwift
import Action

class TabbarViewController: UITabBarController {
    

    let disposeBag = DisposeBag()
    let TABBAR_HEIGHT:CGFloat = 56
    var DEFAULT_TABBAR_HEIGHT:CGFloat = 49
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.tabBar.isTranslucent = true
        self.tabBar.barTintColor = .white
        DEFAULT_TABBAR_HEIGHT = self.tabBar.frame.height
        
        self.tabBar.tintColor = .red
        self.tabBar.unselectedItemTintColor = .black
        UITabBar.setTransparentTabbar()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)], for: .normal)
        self.delegate = self
        tabBar.clipsToBounds = true
        loadViewController()
        addShadow()
        updatelayoutTabbar()
    }
    func addShadow(){
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: CGRect(x: 10, y: 2, width: view.frame.width - 20, height: TABBAR_HEIGHT - 4), cornerRadius: 40).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3
        shadowLayer.masksToBounds = false
        tabBar.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func updatelayoutTabbar(){
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemWidth = (SCREEN_WIDTH - 180)/3
        let bottomPadding = self.view.window?.safeAreaInsets.bottom ?? 0
        if bottomPadding == 0{
            self.additionalSafeAreaInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: (TABBAR_HEIGHT + 4) - DEFAULT_TABBAR_HEIGHT, right: 0)
            tabBar.frame = CGRect(x: tabBar.frame.origin.x, y: self.view.frame.height-(TABBAR_HEIGHT + 4), width: tabBar.frame.size.width, height: TABBAR_HEIGHT)
        }else{
            self.additionalSafeAreaInsets = UIEdgeInsets.init(top: TABBAR_HEIGHT - DEFAULT_TABBAR_HEIGHT, left: 0, bottom: 0, right: 0)
            tabBar.frame = CGRect(x: tabBar.frame.origin.x, y: tabBar.frame.origin.y, width: tabBar.frame.size.width, height: TABBAR_HEIGHT)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadViewController(){
        
        let inputVC = InputViewController(viewModel: InputViewModel())
        let inputNV = UINavigationController.init(rootViewController: inputVC)
        let inputItem = UITabBarItem.init(title: "Nhập", image: R.image.ic_input(), tag: 1000)
        inputItem.badgeColor = .black
        inputNV.tabBarItem = inputItem
        
        let calendarVC = CalendarViewController(viewModel: CalendarViewModel())
        let calendarNV = UINavigationController.init(rootViewController: calendarVC)
        let calendarItem = UITabBarItem.init(title: "Lịch", image: R.image.ic_calendar(), tag: 1001)
        calendarNV.tabBarItem = calendarItem
        
        let reportVC = ReportViewController(viewModel: ReportViewModel())
        let reportNV = UINavigationController.init(rootViewController: reportVC)
        let reportItem = UITabBarItem.init(title: "Báo cáo", image: R.image.ic_chart(), tag: 1002)
        reportNV.tabBarItem = reportItem
        
        self.viewControllers = [inputNV,calendarNV,reportNV]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension TabbarViewController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}
