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
    func bindingViewModels() {
        let input = EditViewModel.Input(onAppear: self.rx.viewWillAppear.asObservable(),
                                          deleteTrigger: deleteTrigger,
                                          editTrigger: editButton.rx.tap.asObservable(),
                                          amount: amountTextField.rx.text.orEmpty.asObservable(),
                                          note: noteTextView.rx.text.orEmpty.asObservable())
        
        let output = viewModel.transfrom(from: input)
        
        output.enableButton.drive(editButton.rx.isEnabled).disposed(by: disposeBag)
        
        output.item.drive{[weak self] item in
            self?.dateTextField.text = item.date
            self?.amountTextField.text = "\(item.amount)"
            self?.categoryLabel.text = item.category
            self?.noteTextView.text = item.note
            if item.type == ItemType.spend.rawValue {
                self?.typeLabel.text = "Tiền chi"
            } else {
                self?.typeLabel.text = "Tiền thu"
            }
        }.disposed(by: disposeBag)
        
        output.deleteSuccess.drive{[weak self] success in
            if success {
                self?.showAlert(message: "Xoá thành công", callback: {
                    self?.dismiss(animated: true, completion: nil)
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
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        buttonDelete.rx.tap.bind{[weak self] in
            self?.showConfirm(message: "Bạn có chắc chắn xoá bản ghi này không?", callback: {
                self?.deleteTrigger.onNext(())
            })
        }.disposed(by: disposeBag)
    }
    func setupViews() {
        editButton.isEnabled = false
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
