//
//  NewsListViewController.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 24.06.2025.
//

import Foundation
import UIKit
import RxSwift
import Stevia
import Router

final class NewsListViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, NewsListDisplayItem>!
    
    private let viewModel: NewsListViewModel!
    private let router: RouterProtocol!
    
    private let bag = DisposeBag()
    
    // MARK: - Life cycle
    
    init(viewModel: NewsListViewModel, router: RouterProtocol) {
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
        viewModel.fetchNewsList()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.setCollectionViewLayout(self.createCompositionalLayout(), animated: true)
        })
    }
    
    // MARK: - Private methods
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let screenHeight = UIScreen.main.bounds.height
        let groupHeight = UIDevice.current.orientation.isPortrait ? screenHeight / 4 : screenHeight * 0.375
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(groupHeight)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, NewsListDisplayItem>(
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
                    
                case .newsList(item: let newsList):
                    if let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: "NewsListCell",
                        for: indexPath
                    ) as? NewsListCell {
                        cell.configure(with: newsList)
                        
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
        collectionView.register(NewsListCell.self, forCellWithReuseIdentifier: "NewsListCell")
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        
        collectionView.Top == view.Top
        collectionView.Bottom == view.Bottom
        collectionView.Leading == view.Leading
        collectionView.Trailing == view.Trailing
        
        configureDataSource()
    }
    
    private func updateSnapshot(with displayedItems: [NewsListDisplayItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, NewsListDisplayItem>()
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
        
        viewModel.goToSelectedNews
            .emit(onNext: { [weak self] newsListItem in
                guard let id = newsListItem.id else { return }
                
                let newsDetailAssembly = NewsDetailAssemblyImpl()
                let newsDetailVC = newsDetailAssembly.assembly(id: id, newsListItem: newsListItem)
                
                self?.router.perform(action: .push(viewController: newsDetailVC, animated: true))
            })
            .disposed(by: bag)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "News list"
        navigationItem.backButtonTitle = ""
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.backgroundColor = .systemBackground
    }
    
}

extension NewsListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectNews(at: indexPath.item)
    }
    
}
