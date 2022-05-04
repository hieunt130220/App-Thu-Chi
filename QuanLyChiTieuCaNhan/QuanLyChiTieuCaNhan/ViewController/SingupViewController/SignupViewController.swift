//
//  SignupViewController.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 25/04/2022.
//

import UIKit
import RxCocoa
class SignupViewController: BaseViewController, BaseViewControllerProtocol {
    var viewModel: SignupViewModel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: AuthButton!
    required init(viewModel: SignupViewModel) {
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
    func bindingViewModels() {
        let input = SignupViewModel.Input(email: emailTextfield.rx.text.orEmpty.asObservable(),
                                          password: passwordTextfield.rx.text.orEmpty.asObservable(),
                                          confirmPassword: confirmPasswordTextfield.rx.text.orEmpty.asObservable(),
                                          signupTrigger: signupButton.rx.tap.asObservable())
        let output = viewModel.transfrom(from: input)
        
        output.errorString.drive {[weak self] msg in
            if !msg.isEmpty {
                self?.errorLabel.text = msg
                self?.errorLabel.isHidden = false
            } else {
                self?.errorLabel.isHidden = true
            }
        }.disposed(by: disposeBag)
        
        output.isSuccess.drive { bool in
            if bool {
                SCENE_DELEGATE?.appNavigator?.switchToMain()
            }
        }.disposed(by: disposeBag)
    }
    func setupRx() {
        loginButton.rx.tap.bind {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    func setupViews() {
        title = "Đăng kí"
        navigationController?.navigationBar.prefersLargeTitles = true
        errorLabel.isHidden = true
    }
}
