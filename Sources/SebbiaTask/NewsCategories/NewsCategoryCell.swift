//
//  NewsCategoryCell.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 07.07.2025.
//

import UIKit
import Stevia

final class NewsCategoryCell: UICollectionViewCell {
   
    // MARK: - Public properties
    
    override var reuseIdentifier: String? {
        "NewsCategoryCell"
    }
    
    // MARK: - Private properties
    
    private lazy var categoryLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1.0
        
        return label
    }()
   
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(categoryLbl)
        categoryLbl.Top == Top + 8
        categoryLbl.Bottom == Bottom - 8
        categoryLbl.Leading == Leading + 8
        categoryLbl.Trailing == Trailing - 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func configure(with category: NewsCategoryList) {
        categoryLbl.text = category.name
    }
    
}
