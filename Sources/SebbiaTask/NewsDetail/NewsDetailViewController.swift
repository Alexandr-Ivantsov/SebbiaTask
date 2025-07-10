//
//  NewsDetailViewController.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 24.06.2025.
//

import Foundation
import UIKit
import RxSwift
import Stevia

final class NewsDetailViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let titleLbl = UILabel()
    private let shortDescriptionLbl = UILabel()
    private let fullDescriptionTxtView = UITextView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let newsListItem: NewsListItem!
    private let viewModel: NewsDetailViewModel!
    
    private let bag = DisposeBag()
    
    // MARK: - Life cycle
    
    init(viewModel: NewsDetailViewModel, newsListItem: NewsListItem) {
        self.viewModel = viewModel
        self.newsListItem = newsListItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embedViews()
        setupLayout()
        setupAppereance()
        setupBindings()
        setupNavigationBar()
        viewModel.fetchNewsDetail()
    }
    
    // MARK: - Private methods
    
    private func embedViews() {
        [
            titleLbl,
            shortDescriptionLbl,
            fullDescriptionTxtView,
            activityIndicator
        ].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupLayout() {
        titleLbl.Top == view.safeAreaLayoutGuide.Top + 8
        titleLbl.Leading == view.Leading + 8
        titleLbl.Trailing == view.Trailing - 8
        titleLbl.Height == 80
        
        shortDescriptionLbl.Top == titleLbl.Bottom + 8
        shortDescriptionLbl.Leading == view.Leading + 8
        shortDescriptionLbl.Trailing == view.Trailing - 8
        shortDescriptionLbl.Height == 100
        
        fullDescriptionTxtView.Top == shortDescriptionLbl.Bottom + 8
        fullDescriptionTxtView.Leading == view.Leading + 8
        fullDescriptionTxtView.Trailing == view.Trailing - 8
        fullDescriptionTxtView.Height == 200
        
        activityIndicator.CenterX == fullDescriptionTxtView.CenterX
        activityIndicator.CenterY == fullDescriptionTxtView.CenterY
    }
    
    private func setupAppereance() {
        view.backgroundColor = .systemBackground
        
        titleLbl.numberOfLines = 0
        titleLbl.font = .systemFont(ofSize: 17, weight: .bold)
        titleLbl.textAlignment = .center
        titleLbl.textColor = .label
        titleLbl.text = newsListItem.title
        
        shortDescriptionLbl.numberOfLines = 0
        shortDescriptionLbl.textAlignment = .left
        shortDescriptionLbl.textColor = .secondaryLabel
        shortDescriptionLbl.font = .systemFont(ofSize: 15)
        shortDescriptionLbl.text = newsListItem.shortDescription
        
        
        fullDescriptionTxtView.isEditable = false
        fullDescriptionTxtView.dataDetectorTypes = [.link]
        fullDescriptionTxtView.textAlignment = .left
    }
    
    private func setupBindings() {
        viewModel.state
            .emit(onNext: { [weak self] state in
                guard let self else { return }
                
                switch state {
                case .loading:
                    self.fullDescriptionTxtView.isHidden = true
                    self.activityIndicator.startAnimating()
                case .loaded(let attributedString):
                    self.activityIndicator.stopAnimating()
                    self.fullDescriptionTxtView.isHidden = false
                    self.fullDescriptionTxtView.attributedText = attributedString
                case .error(let alertData):
                    showAlert(with: alertData)
                }
            })
            .disposed(by: bag)
        
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "News detail"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
    }

}
