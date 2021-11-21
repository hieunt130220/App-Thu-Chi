//
//  CategoryCollectionViewCell.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 11/11/2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    override var isSelected: Bool{
        didSet{
            if isSelected{
                self.backgroundColor = .orange
            }else{
                self.backgroundColor = .gray.withAlphaComponent(0.4)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .gray.withAlphaComponent(0.4)
    }
    func setData(category: CategoryModel) {
//        icon.image = UIImage(named: category.icon)
        title.text = category.title
    }
}
