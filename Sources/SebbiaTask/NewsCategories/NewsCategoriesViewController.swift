//
//  NewsCategoriesViewController.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 24.06.2025.
//

import Foundation
import UIKit
import Stevia
import RxSwift
import Router

final class NewsCategoriesViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, NewsCategoriesDisplayItem>!
    
    private let viewModel: NewsCategoriesViewModel!
    private let router: RouterProtocol!
    
    private let bag = DisposeBag()
    
    // MARK: - Life cycle
    
    init(viewModel: NewsCategoriesViewModel, router: RouterProtocol) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        setupBindings()
        viewModel.fetchNewsCategories()
    }
    
    // MARK: - Private methods
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.1)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, NewsCategoriesDisplayItem>(
            collectionView: collectionView) {
                (collectionView, indexPath, newsCategoryDisplayItem) -> UICollectionViewCell? in
                switch newsCategoryDisplayItem {
                case .loading(_):
                    if let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: "SkeletonCell",
                        for: indexPath
                    ) as? SkeletonCell {
                        
                        cell.setShimmering()
                        
                        return cell
                    }
                    
                case .news(category: let category):
                    if let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: "NewsCategoryCell",
                        for: indexPath
                    ) as? NewsCategoryCell {
                        cell.configure(with: category)
                        
                        return cell
                    }
                }
                
                return nil
            }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SkeletonCell.self, forCellWithReuseIdentifier: "SkeletonCell")
        collectionView.register(NewsCategoryCell.self, forCellWithReuseIdentifier: "NewsCategoryCell")
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        
        collectionView.Top == view.Top
        collectionView.Bottom == view.Bottom
        collectionView.Leading == view.Leading
        collectionView.Trailing == view.Trailing
        
        configureDataSource()
    }
    
    private func updateSnapshot(with displayedItems: [NewsCategoriesDisplayItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, NewsCategoriesDisplayItem>()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(displayedItems)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupBindings() {
        viewModel.state
            .emit(onNext: { [weak self] state in
                guard let self else { return }
                
                switch state {
                case .loading:
                    self.updateSnapshot(with: self.viewModel.getDisplayItems())
                case .loaded(let displayItems):
                    self.updateSnapshot(with: displayItems)
                case .error(let alertData):
                    showAlert(with: alertData)
                }
            })
            .disposed(by: bag)
        
        viewModel.goToSelectedCategory
            .emit(onNext: { [weak self] categoryId in
                guard let self else { return }
                
                let newsListAssembly = NewsListAssemblyImpl(router: self.router)
                let newsListVC = newsListAssembly.assembly(id: categoryId)
                
                self.router.perform(action: .push(viewController: newsListVC, animated: true))
            })
            .disposed(by: bag)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "News Categories"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
    }

}

// MARK: - UICollectionViewDelegate

extension NewsCategoriesViewController: UICollectionViewDelegate {
    
    func  collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectCategory(at: indexPath.item)
    }
    
}
