//
//  DetailReportViewController.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 21/11/2021.
//

import UIKit
import Charts
import RxSwift
import RxCocoa
class DetailReportViewController: BaseViewController, BaseViewControllerProtocol {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: DetailReportViewModel!
    let arrayTotal = BehaviorRelay<[Int]>(value: [])
    required init(viewModel: DetailReportViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingViewModels()
        setupRx()
        setupViews()
        // Do any additional setup after loading the view.
    }
    func bindingViewModels() {
        let input = DetailReportViewModel.Input(onApear: self.rx.viewWillAppear.asObservable())
        
        let output = viewModel.transfrom(from: input)
        
        output.totalArray.drive{[weak self] array in
            self?.arrayTotal.accept(array)
            self?.setDataCount(data: array)
        }.disposed(by: disposeBag)
    }
    func setupRx() {
        backButton.rx.tap.bind{[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    func setupViews() {
        self.titleLabel.text = self.viewModel.category
        self.setup(barLineChartView: barChartView)
        
        barChartView.delegate = self
        
        barChartView.drawBarShadowEnabled = false
        barChartView.drawValueAboveBarEnabled = false
        barChartView.maxVisibleCount = 60
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 12
        xAxis.valueFormatter = DayAxisValueFormatter(chart: barChartView)

        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 2
        
        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0
        
        let marker = XYMarkerView(color: UIColor(white: 180/250, alpha: 0.7),
                                  font: UIFont.systemFont(ofSize: 12),
                                  textColor: UIColor.white,
                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                  xAxisValueFormatter: barChartView.xAxis.valueFormatter!)
        marker.minimumSize = CGSize(width: 80, height: 40)
        barChartView.marker = marker
    }
    func setup(barLineChartView chartView: BarLineChartViewBase) {
        chartView.chartDescription?.enabled = false
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bothSided
        chartView.rightAxis.enabled = false
        
    }
    func setDataCount(data: [Int]) {
        let yVals = (1...data.count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i-1), y: Double(data[i-1]))
        }
        let set1 = BarChartDataSet(entries: yVals, label: "")
        set1.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        data.barWidth = 0.8
        barChartView.data = data
        barChartView.animate(yAxisDuration: 1)
        let curentMonth = self.viewModel.time.month
        barChartView.highlightValue(x: Double(curentMonth - 1), dataSetIndex: 0)
    }
}
extension DetailReportViewController: ChartViewDelegate {
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}
