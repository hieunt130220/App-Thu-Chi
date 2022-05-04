//
//  LoginViewController.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 25/04/2022.
//

import UIKit
import RxCocoa
class LoginViewController: BaseViewController, BaseViewControllerProtocol {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: AuthButton!
    var viewModel: LoginViewModel!
    required init(viewModel: LoginViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupRx()
        bindingViewModels()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    func setupRx() {
        signupButton.rx.tap.bind {[weak self] in
            let vc = SignupViewController(viewModel: .init())
            self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    func setupViews() {
        title = "Đăng nhập"
        navigationController?.navigationBar.prefersLargeTitles = true
        errorLabel.isHidden = true
        loginButton.isEnabled = false
    }
    func bindingViewModels() {
        
    }
}
