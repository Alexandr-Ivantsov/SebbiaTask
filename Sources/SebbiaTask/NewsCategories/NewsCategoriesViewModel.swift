//
//  NewsCategoriesViewModel.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 24.06.2025.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum NewsCategoriesState {
    case loading
    case loaded([NewsCategoriesDisplayItem])
    case error(AlertData)
}

protocol NewsCategoriesViewModel: AnyObject {
    var goToSelectedCategory: Signal<Int> { get }
    var state: Signal<NewsCategoriesState> { get }
    
    func fetchNewsCategories()
    func selectCategory(at index: Int)
    func getDisplayItems() -> [NewsCategoriesDisplayItem]
}

final class NewsCategoriesViewModelImpl: NewsCategoriesViewModel {
    
    // MARK: - Public properties
    
    var goToSelectedCategory: Signal<Int> { _goToSelectedCategory.asSignal() }
    var state: Signal<NewsCategoriesState> { _state.asSignal() }
    
    // MARK: - Private properties
    
    private let _goToSelectedCategory = PublishRelay<Int>()
    private let _state = PublishRelay<NewsCategoriesState>()
    private let bag = DisposeBag()
    
    private let newsCategoriesUseCase: NewsCategoriesUseCase!
    private var newsCategoriesDisplayItems: [NewsCategoriesDisplayItem] = [
        .loading(id: -3),
        .loading(id: -2),
        .loading(id: -1)
    ]
    
    // MARK: - Life cycle
    
    init(newsCategoriesUseCase: NewsCategoriesUseCase) {
        self.newsCategoriesUseCase = newsCategoriesUseCase
    }

    // MARK: - Public methods
    
    func fetchNewsCategories() {
        set(state: .loading)
        
        newsCategoriesUseCase.getCategories()
            .subscribe(onSuccess: { [weak self] categories in
                self?.set(
                    state: .loaded(self?.generateDisplayItems(from: categories) ?? [])
                )
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

    func selectCategory(at index: Int) {
        _goToSelectedCategory.accept(index)
    }
    
    func getDisplayItems() -> [NewsCategoriesDisplayItem] {
        return newsCategoriesDisplayItems
    }
    
    // MARK: - Private methods
    
    private func generateDisplayItems(from category: NewsCategory) -> [NewsCategoriesDisplayItem] {
        return category.list?.compactMap {
            NewsCategoriesDisplayItem.news(category: $0)
        } ?? []
    }
    
    private func set(state: NewsCategoriesState) {
        _state.accept(state)
    }
    
}
