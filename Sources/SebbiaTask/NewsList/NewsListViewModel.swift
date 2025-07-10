//
//  NewsListViewModel.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 24.06.2025.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum NewsListState {
    case loading
    case loaded([NewsListDisplayItem])
    case error(AlertData)
}

protocol NewsListViewModel: AnyObject {
    var goToSelectedNews: Signal<NewsListItem> { get }
    var state: Signal<NewsListState> { get }
    
    func fetchNewsList()
    func selectNews(at id: Int)
    func set(state: NewsListState)
    func getDisplayItems() -> [NewsListDisplayItem]
}

final class NewsListViewModelImpl: NewsListViewModel {
    
    // MARK: - Public properties
    
    var goToSelectedNews: Signal<NewsListItem> { _goToSelectedNews.asSignal() }
    var state: Signal<NewsListState> { _state.asSignal() }
    
    // MARK: - Private properties
    private let _goToSelectedNews = PublishRelay<NewsListItem>()
    private let _state = PublishRelay<NewsListState>()
    private let bag = DisposeBag()
    
    private let newsListUseCase: NewsListUseCase!
    private var newsListDisplayItems: [NewsListDisplayItem] = [
        .loading(id: -3),
        .loading(id: -2),
        .loading(id: -1)
    ]
    
    // MARK: - Life cycle
    
    init(newsListUseCase: NewsListUseCase) {
        self.newsListUseCase = newsListUseCase
    }

    // MARK: - Public methods
    
    func fetchNewsList() {
        set(state: .loading)
        
        newsListUseCase.getNewsList()
            .subscribe(onSuccess: { [weak self] newsList in
                self?.set(state: .loaded(self?.generateDisplayItems(from: newsList) ?? []))
            }, onFailure: { [weak self] _ in
                self?.set(
                    state: .error(
                        AlertData(
                            title: "Something went wrong",
                            message: "Please try again later",
                            actionTitle: "Ok",
                            actionHandler: nil
                        )
                    )
                )
            })
            .disposed(by: bag)
        
    }

    func selectNews(at index: Int) {
        switch newsListDisplayItems[index] {
        case .loading(id: _):
            return
        case .newsList(item: let item):
            _goToSelectedNews.accept(item)
        }
    }
    
    func set(state: NewsListState) {
        _state.accept(state)
    }
    
    func getDisplayItems() -> [NewsListDisplayItem] {
        return newsListDisplayItems
    }
    
    // MARK: - Private methods
    
    private func generateDisplayItems(from newsList: NewsList) -> [NewsListDisplayItem] {
        newsListDisplayItems = newsList.list?.compactMap {
            NewsListDisplayItem.newsList(item: $0)
        } ?? []
        
        return newsListDisplayItems
    }
    
}
