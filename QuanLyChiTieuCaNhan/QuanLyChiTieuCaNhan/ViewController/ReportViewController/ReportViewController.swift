//
//  ReportViewController.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 11/11/2021.
//

import UIKit
import RxSwift
import Charts
class ReportViewController: BaseViewController, BaseViewControllerProtocol {
    
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeSegment: UISegmentedControl!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var spendLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var chartView: PieChartView!
    var viewModel: ReportViewModel!
    let timeObserve = PublishSubject<Date>()
    let monthPicker = NTMonthYearPicker()
    required init(viewModel: ReportViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    var result = [[String:Any]]()
    var income = Int()
    var spend = Int()
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
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.heightTableView.constant = newSize.height
                }
            }
        }
    }
    func bindingViewModels() {
        let input = ReportViewModel.Input(dateTrigger: timeObserve,
                                          typeTrigger: typeSegment.rx.selectedSegmentIndex.startWith(0).asObservable(),
                                          periodTrigger: timeSegment.rx.selectedSegmentIndex.startWith(0).asObservable())
        let output = viewModel.transfrom(from: input)
        output.allData.drive(
            tableView.rx.items(cellIdentifier: HistoryTableViewCell.className, cellType: HistoryTableViewCell.self)) {[weak self] row, item, cell in
                cell.setDataReport(item: item)
            }.disposed(by: disposeBag)
        output.totalIncome.drive{[weak self] income in
            self?.incomeLabel.text = income.formatCurrency()
            self?.income = income
        }.disposed(by: disposeBag)
        output.totalSpend.drive{[weak self] spend in
            self?.spendLabel.text = spend.formatCurrency()
            self?.spend = spend
        }.disposed(by: disposeBag)
        output.total.drive{[weak self] total in
            self?.totalLabel.text = total.formatCurrency()
        }.disposed(by: disposeBag)
        
        output.dataChart.drive{[weak self]data in
            self?.setDataCount(dataValue: data)
        }.disposed(by: disposeBag)
    }
    func setupRx() {
        timeObserve.onNext(Date())
        
        timeTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: {[weak self] in
                guard let weakself = self else { return }
                weakself.timeObserve.onNext(weakself.monthPicker.date)
                weakself.timeTextField.text = weakself.monthPicker.date.stringWith(format: weakself.timeSegment.selectedSegmentIndex == 0 ? "MM/yyyy" : "yyyy")
            }).disposed(by: disposeBag)
        
        timeSegment.rx.selectedSegmentIndex
            .subscribe(onNext: {[weak self] index in
                guard let weakself = self else { return }
                weakself.timeTextField.text = weakself.monthPicker.date.stringWith(format: index == 0 ? "MM/yyyy" : "yyyy")
                self?.monthPicker.datePickerMode = NTMonthYearPickerMode(UInt32(index))
            }).disposed(by: disposeBag)
    }
    func setupViews() {
        monthPicker.datePickerMode = NTMonthYearPickerMode(0)
        monthPicker.locale = Locale(identifier: "vi_VN")
        monthPicker.calendar.timeZone = TimeZone.current
        timeTextField.text = Date().stringWith(format: "MM/yyyy")
        timeTextField.tintColor = .clear
        timeTextField.inputView = monthPicker
        
        tableView.register(UINib(nibName: HistoryTableViewCell.className, bundle: nil), forCellReuseIdentifier: HistoryTableViewCell.className)
        tableView.rowHeight = 70
    }
    func setDataCount(dataValue: [[String:Any]]) {
        let entries = (0..<dataValue.count).map { (i) -> PieChartDataEntry in
            return PieChartDataEntry(value: Double(dataValue[i].values.first as! CGFloat),
                                     label:  dataValue[i].keys.first!)
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.entryLabelColor = NSUIColor.black
        set.colors = ChartColorTemplates.vordiplom()
        + ChartColorTemplates.joyful()

        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 2
        pFormatter.minimumFractionDigits = 2
        pFormatter.multiplier = 100
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        chartView.drawEntryLabelsEnabled = false
        chartView.data = data
        chartView.highlightValues(nil)
        chartView.animate(xAxisDuration: 1.0)
                
    }
}
