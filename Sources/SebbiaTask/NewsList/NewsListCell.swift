//
//  NewsListCell.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 08.07.2025.
//

import UIKit
import Stevia

final class NewsListCell: UICollectionViewCell {
   
    // MARK: - Public properties
    
    override var reuseIdentifier: String? {
        "NewsListCell"
    }
    
    // MARK: - Private properties
    
    private lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var dateLbl: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var shortDescriptionLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
   
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLbl)
        addSubview(dateLbl)
        addSubview(shortDescriptionLbl)
        
        titleLbl.Top == Top + 8
        dateLbl.Top == titleLbl.Bottom + 8
        shortDescriptionLbl.Top == dateLbl.Bottom + 8
        
        titleLbl.Leading == Leading + 8
        dateLbl.Leading == Leading + 8
        shortDescriptionLbl.Leading == Leading + 8

        titleLbl.Width == Width - 16
        dateLbl.Width == Width - 16
        shortDescriptionLbl.Width == Width - 16
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func configure(with newsList: NewsListItem) {
        titleLbl.text = newsList.title
        dateLbl.text = newsList.date
        shortDescriptionLbl.text = newsList.shortDescription
    }
    
}
