//
//  CalendarViewController.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 11/11/2021.
//

import UIKit
import RxSwift
import RxCocoa
import FSCalendar
class CalendarViewController: BaseViewController, BaseViewControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var labelIncome: UILabel!
    @IBOutlet weak var labelSpend: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    var viewModel: CalendarViewModel!
    let dateSelected = PublishSubject<Date>()
    fileprivate var preDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModels()
        setupRx()
        setupViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    required init(viewModel: CalendarViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    required init?(coder: NSCoder) {
        fatalError("")
    }
    func bindingViewModels() {
        let input = CalendarViewModel.Input(dateSelected: dateSelected)
        
        let output = viewModel.transfrom(from: input)

        output.arrayHistory
            .drive(tableView.rx.items(cellIdentifier: HistoryTableViewCell.className, cellType: HistoryTableViewCell.self)){row, item, cell in
                cell.setData(item: item)
            }.disposed(by: disposeBag)
        output.totalIncome.drive(labelIncome.rx.text).disposed(by: disposeBag)
        output.totalSpend.drive(labelSpend.rx.text).disposed(by: disposeBag)
        output.total.drive(labelTotal.rx.text).disposed(by: disposeBag)
        
        
    }
    func setupViews() {
        calendar.locale = Locale(identifier: "vi_VN")
        calendar.delegate = self
        tableView.register(UINib(nibName: HistoryTableViewCell.className, bundle: nil), forCellReuseIdentifier: HistoryTableViewCell.className)
        tableView.rowHeight = 70
    }
    func setupRx() {
        dateSelected.onNext(Date())
        
        tableView.rx.modelSelected(ItemModel.self)
            .subscribe(onNext: {[weak self] item in
                let vc = EditViewController(viewModel: .init(item: item))
                self?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dateSelected.onNext(date)
        if date.localDate().month != preDate.localDate().month {
            self.calendar.select(date, scrollToDate: true)
        }
        preDate = date.localDate()
    }
}

