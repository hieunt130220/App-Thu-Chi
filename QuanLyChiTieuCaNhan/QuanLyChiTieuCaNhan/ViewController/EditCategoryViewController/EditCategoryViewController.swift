//
//  EditCategoryViewController.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 21/11/2021.
//

import UIKit
import RxSwift
import RxCocoa
class EditCategoryViewController: BaseViewController, BaseViewControllerProtocol {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var tableViewCategory: UITableView!
    var viewModel: EditCategoryViewModel!
    
    let allCategories = BehaviorRelay<[CategoryModel]>(value: [])
    let addTrigger = PublishSubject<Void>()
    let newCategoryTitle = PublishSubject<String>()
    let deleteTrigger = PublishSubject<CategoryModel>()
    required init(viewModel: EditCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModels()
        setupRx()
        setupViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    func setupRx() {
        buttonBack.rx.tap.bind{[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    func setupViews() {
        tableViewCategory.dataSource = self
        tableViewCategory.delegate = self
        typeSegment.selectedSegmentIndex = viewModel.type
    }
    func bindingViewModels() {
        let input = EditCategoryViewModel.Input(onAppear: rx.viewWillAppear.asObservable(), deleteTrigger: deleteTrigger,
                                                newCategory: newCategoryTitle,
                                                typeTrigger: typeSegment.rx.selectedSegmentIndex.asObservable(),
                                                addTrigger: addTrigger)
        let output = viewModel.transfrom(from: input)
        
        output.allCategories.drive {[weak self] categories in
            self?.allCategories.accept(categories)
            self?.tableViewCategory.reloadData()
        }.disposed(by: disposeBag)
        output.newCategory.drive{[weak self] category in
            self?.allCategories.accept((self?.allCategories.value)! + [category])
            self?.tableViewCategory.reloadData()
        }.disposed(by: disposeBag)
        
        output.addSuccess.drive{[weak self] success in
            if success {
                self?.showAlert(message: "Thêm thành công", callback: {
                    
                })
            } else {
                self?.showAlert(message: "Danh mục không hợp lệ", callback: {
                    
                })
            }
        }.disposed(by: disposeBag)
    }
}
extension EditCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCategories.value.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "")
        cell.selectionStyle = .none
        cell.textLabel?.text = allCategories.value[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row > 0 {
            let delete = UIContextualAction(style: .destructive, title: "Xoá") {[weak self] _, _, _ in
                self?.deleteTrigger.onNext(self!.allCategories.value[indexPath.row])
                self?.allCategories.accept(self!.allCategories.value.filter{$0 != self!.allCategories.value[indexPath.row]})
                tableView.deleteRows(at: [indexPath], with: .left)
                tableView.reloadData()
            }
            delete.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [delete])
        }
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alert = UIAlertController(title: "Danh mục mới", message: nil, preferredStyle: .alert)
            let newCate = BehaviorRelay<String>(value: "")
            alert.addTextField {[weak self] tf in
                tf.rx.text.orEmpty.bind(to: newCate).disposed(by: self!.disposeBag)
            }
            alert.addAction(UIAlertAction(title: "Xong", style: .default, handler: { [weak self] _ in
                self?.newCategoryTitle.onNext(newCate.value)
                self?.addTrigger.onNext(())
            }))
            alert.addAction(UIAlertAction(title: "Huỷ", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
