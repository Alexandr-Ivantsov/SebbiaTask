//
//  NewsDIContainer.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 24.06.2025.
//

import Foundation
import Factory
import CacheManagerWithoutKeychain
import UIKit
import Router

final class NewsDIContainer: SharedContainer {

    // MARK: - Public properties

    let manager = ContainerManager()

    static var shared = NewsDIContainer()

    // MARK: - Life cycle

    private init() {}

    // MARK: - NewsCategoriesRepository
    
    var newsCategoriesRepository: NewsCategoriesRepository {
        NewsCategoriesRepositoryImpl()
    }
    
    // MARK: - NewsCategoriesUseCase
    
    var newsCategoriesUseCase: NewsCategoriesUseCase {
        NewsCategoriesUseCaseImpl(
            repository: newsCategoriesRepository,
            cacheUseCase: CacheDIContainer.shared.cacheUseCase
        )
    }
    
    // MARK: - NewsCategoriesViewModel
    
    var newsCategoriesViewModel: NewsCategoriesViewModel {
        NewsCategoriesViewModelImpl(
            newsCategoriesUseCase: newsCategoriesUseCase
        )
    }
    
    // MARK: - NewsListRepository
    
    var newsListRepository: NewsListRepository {
        NewsListRepositoryImpl()
    }
    
    // MARK: - NewsDetailRepository
    
    var newsDetailRepository: NewsDetailRepository {
        NewsDetailRepositoryImpl()
    }
    
    // MARK: - NewsDetailUseCase
    
    func makeNewsDetailUseCase(id: Int) -> NewsDetailUseCase {
        NewsDetailUseCaseImpl(
            repository: newsDetailRepository,
            cacheUseCase: CacheDIContainer.shared.cacheUseCase,
            id: id
        )
    }
    
    // MARK: - NewsListUseCase
    
    func makeNewsListUseCase(id: Int) -> NewsListUseCase {
        NewsListUseCaseImpl(
            repository: newsListRepository,
            cacheUseCase: CacheDIContainer.shared.cacheUseCase,
            id: id
        )
    }
    
    // MARK: - NewsListViewModel
    
    func makeNewsListViewModel(id: Int) -> NewsListViewModel {
        NewsListViewModelImpl(
            newsListUseCase: makeNewsListUseCase(id: id)
        )
    }

    // MARK: - NewsDetailViewModel
    
    func makeNewsDetailViewModel(id: Int) -> NewsDetailViewModel {
        NewsDetailViewModelImpl(
            newsDetailUseCase: makeNewsDetailUseCase(id: id)
        )
    }
    
}
