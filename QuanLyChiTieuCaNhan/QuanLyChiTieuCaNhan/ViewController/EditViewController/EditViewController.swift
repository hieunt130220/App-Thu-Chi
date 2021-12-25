//
//  DetailViewController.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 20/11/2021.
//

import UIKit
import RxSwift
import RxCocoa
import UITextView_Placeholder
class EditViewController: BaseViewController, BaseViewControllerProtocol {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var noteTextView: BaseTextView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountTextField: BaseTextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var editButton: ButtonConfirm!
    let amount = PublishSubject<String>()
    let deleteTrigger = PublishSubject<Void>()
    var viewModel: EditViewModel!
    required init(viewModel: EditViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindingViewModels()
        setupViews()
        setupRx()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    func bindingViewModels() {
        let input = EditViewModel.Input(onAppear: self.rx.viewWillAppear.asObservable(),
                                          deleteTrigger: deleteTrigger,
                                          editTrigger: editButton.rx.tap.asObservable(),
                                        amount: amount,
                                          note: noteTextView.rx.text.orEmpty.asObservable())
        
        let output = viewModel.transfrom(from: input)
        
        output.amountError.drive{[weak self] error in
            if error {
                self?.showAlert(message: "Số tiền phải khác 0", callback: {
                    
                })
            }
        }.disposed(by: disposeBag)
        
        output.item.drive{[weak self] item in
            self?.dateTextField.text = item.date
            self?.amountTextField.rx.text.onNext("\(item.amount)")
            self?.categoryLabel.text = item.category
            self?.noteTextView.text = item.note
            if item.type == ItemType.spend.rawValue {
                self?.typeLabel.text = "Tiền chi"
            } else {
                self?.typeLabel.text = "Tiền thu"
            }
            self?.amount.onNext("\(item.amount)")
        }.disposed(by: disposeBag)
        
        output.deleteSuccess.drive{[weak self] success in
            if success {
                self?.showAlert(message: "Xoá thành công", callback: {
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        }.disposed(by: disposeBag)
        
        output.editSuccess.drive{[weak self] success in
            if success {
                self?.showAlert(message: "Sửa thành công", callback: {
                    
                })
            }
        }.disposed(by: disposeBag)
    }
    func setupRx() {
        buttonBack.rx.tap.bind{[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        buttonDelete.rx.tap.bind{[weak self] in
            self?.showConfirm(message: "Bạn có chắc chắn xoá bản ghi này không?", callback: {
                self?.deleteTrigger.onNext(())
            })
        }.disposed(by: disposeBag)
        amountTextField.rx.text.orEmpty.bind(to: amount).disposed(by: disposeBag)
    }
    func setupViews() {
        editButton.isEnabled = true
        noteTextView.placeholder = "Ghi chú thích"
        noteTextView.autocorrectionType = .no
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
