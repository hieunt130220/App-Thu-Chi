//
//  HistoryTableViewCell.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 12/11/2021.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(item: ItemModel) {
        titleLabel.text = item.category
        amountLabel.text = item.amount.formatCurrency()
        if item.type == ItemType.income.rawValue {
            amountLabel.textColor = .blue
        } else {
            amountLabel.textColor = .red
        }
    }
    func setDataReport(item: [String:Any]) {
        titleLabel.text = item.keys.first
        amountLabel.text = (item.values.first as! Int).formatCurrency()
    }
}
