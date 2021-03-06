//
//  InputViewController.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 11/11/2021.
//

import UIKit
import RxSwift
import RxRelay
class InputViewController: BaseViewController, BaseViewControllerProtocol {

    @IBOutlet weak var heightOfCollectionView: NSLayoutConstraint!
    @IBOutlet weak var tabSegment: UISegmentedControl!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var moneyTextField: BaseTextField!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var labelType: UILabel!
    
    let categories = BehaviorRelay<[CategoryModel]>(value: [])
    let categorySelected = BehaviorRelay<String>(value: "")
    let dateSelected = BehaviorRelay<Date>(value: Date())
    var viewModel: InputViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
        bindingViewModels()
        setupRx()
        setupViews()
        configLayoutCollectionView()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        let height = categoryCollectionView.collectionViewLayout.collectionViewContentSize.height
//        heightOfCollectionView.constant = height
    }
    required init(viewModel: InputViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    required init?(coder: NSCoder) {
        fatalError("")
    }
    func bindingViewModels() {
        let input = InputViewModel.Input(onAppear: rx.viewWillAppear.asObservable(),
                                         type: tabSegment.rx.selectedSegmentIndex.asObservable(),
                                         date: dateSelected.asObservable(),
                                         note: noteTextView.rx.text.orEmpty.asObservable(),
                                         category: categorySelected.asObservable(),
                                         amount: moneyTextField.rx.text.orEmpty.asObservable(),
                                         doneTrigger: doneButton.rx.tap.asObservable())
        
        let output = viewModel.transfrom(from: input)
        
        output.categories.drive(categoryCollectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.className, cellType: CategoryCollectionViewCell.self)) { row, item, cell in
            cell.setData(category: item)
        }.disposed(by: disposeBag)

        output.addSuccess.drive{[weak self] isSuccess in
            if isSuccess {
                self?.showAlert(message: "Thêm thành công", callback: {
                    self?.noteTextView.rx.text.onNext("")
                    self?.moneyTextField.rx.text.onNext("")
                    self?.categoryCollectionView.reloadData()
                    self?.categorySelected.accept("")
                    self?.doneButton.isEnabled = false
                })
            }
        }.disposed(by: disposeBag)
        
        output.currentTab
            .drive{[weak self] tab in
                self?.labelType.text = tab.description
                self?.moneyTextField.rx.text.onNext("")
                self?.noteTextView.rx.text.onNext("")
                switch tab {
                case .income:
                    self?.categorySelected.accept("")
                case .spend:
                    self?.categorySelected.accept("")
                }
            }.disposed(by: disposeBag)
        
        output.enableButton.drive(doneButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func register() {
        categoryCollectionView.register(UINib(nibName: CategoryCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.className)
    }
    func configLayoutCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (SCREEN_WIDTH - 50) / 3, height: 80)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        categoryCollectionView.collectionViewLayout = layout
    }
    func setupRx() {
        categoryCollectionView.rx.modelSelected(CategoryModel.self)
            .subscribe(onNext: {[weak self] category in
                if category.title == "Chỉnh sửa" {
                    let vc = EditCategoryViewController(viewModel: .init(type: ItemType(rawValue: (self?.tabSegment.selectedSegmentIndex)!)!))
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self?.categorySelected.accept(category.title)
                }
            }).disposed(by: disposeBag)
    }
    func setupViews() {
        dateTextField.text = Date().stringWith(format: "dd/MM/yyyy")
        dateTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
        dateTextField.tintColor = .clear
    }
    @objc func doneButtonPressed() {
        if let  datePicker = self.dateTextField.inputView as? UIDatePicker {
            self.dateTextField.text = datePicker.date.stringWith(format: "dd/MM/yyyy")
            datePicker.rx.date.bind(to: dateSelected).disposed(by: disposeBag)
        }
        self.dateTextField.resignFirstResponder()
     }
}
