//
//  AppNavigator.swift
//  daibet_ios
//
//  Created by duchung on 14/02/2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol AppNavigatorType: class {
    var window: UIWindow? { get }
    func start()
    func checkLogin()
    func switchToLogin()
    func switchToMain()
    func switchTo(viewController: UIViewController)
    func handleUrl(url: URL)
    var handleAuthUrl: BehaviorRelay<(AppNavigatorRoute, String)?> { get set }
    func clearAuthUrlLink()
}

final class AppNavigator: AppNavigatorType {
    var handleAuthUrl = BehaviorRelay<(AppNavigatorRoute, String)?>(value: nil)
    
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func splash() {
        
    }
    
    func start() {
        checkLogin()
    }
    
    func checkLogin() {
        if Settings.shared.isLogin {
            switchToMain()
        } else {
            switchToLogin()
        }
    }
    
    func handleUrl(url: URL) {
        guard let route = AppNavigatorRoute.check(with: url) else { clearAuthUrlLink(); return }
        if window?.rootViewController is TabbarViewController {
            clearAuthUrlLink()
            return
        }
        handleAuthUrl.accept((route, url.lastPathComponent))
    }
    
    func switchToLogin() {
        let rootVC = LoginViewController(viewModel: .init())
        let navigation = UINavigationController(rootViewController: rootVC)
        Settings.shared.isLogin = false
        switchTo(viewController: navigation)
    }
    
    func switchToMain() {
        let rootVC = TabbarViewController()
        switchTo(viewController: rootVC)
    }
    
    func switchTo(viewController: UIViewController) {
        guard let window = window else { return }
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve],
                          animations: {}, completion: {completed in
        })
    }
    
    func clearAuthUrlLink() {
        handleAuthUrl.accept(nil)
    }
}

enum AppNavigatorRoute: String, CaseIterable {
    case loginEmail = "EmailAuth"
    case register = "UsrReg"
    
    func isContain(in url: URL) -> Bool {
        return url.path.contains(self.rawValue)
    }
    
    static func check(with url: URL) -> AppNavigatorRoute? {
       return AppNavigatorRoute.allCases.filter { $0.isContain(in: url) }.first
    }
}

