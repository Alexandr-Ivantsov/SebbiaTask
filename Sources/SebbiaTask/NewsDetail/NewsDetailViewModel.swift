//
//  NewsDetailViewModel.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 24.06.2025.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum NewsDetailState {
    case loading
    case loaded(NSAttributedString)
    case error(AlertData)
}

protocol NewsDetailViewModel: AnyObject {
    var state: Signal<NewsDetailState> { get }
    
    func fetchNewsDetail()
    func set(state: NewsDetailState)
    func getDisplayItems() -> [NewsDetailDisplayItem]
}

final class NewsDetailViewModelImpl: NewsDetailViewModel {
    
    // MARK: - Public properties
    
    var state: Signal<NewsDetailState> { _state.asSignal() }
    
    // MARK: - Private properties
    private let _state = PublishRelay<NewsDetailState>()
    private let bag = DisposeBag()
    
    private let newsDetailUseCase: NewsDetailUseCase!
    private var newsDetailDisplayItem: [NewsDetailDisplayItem] = [
        .loading(id: -3),
        .loading(id: -2),
        .loading(id: -1)
    ]
    
    // MARK: - Life cycle
    
    init(newsDetailUseCase: NewsDetailUseCase) {
        self.newsDetailUseCase = newsDetailUseCase
    }

    // MARK: - Public methods
    
    func fetchNewsDetail() {
        set(state: .loading)
        
        newsDetailUseCase.getNewsDetail()
            .subscribe(onSuccess: { [weak self] newsDetail in
                guard let self,
                let attributedString = self.attributedString(from: newsDetail.news.fullDescription) else { return }

                self.set(state: .loaded(attributedString))
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
    
    func set(state: NewsDetailState) {
        _state.accept(state)
    }
    
    func getDisplayItems() -> [NewsDetailDisplayItem] {
        return newsDetailDisplayItem
    }
    
    // MARK: - Private methods
    
    private func attributedString(from html: String?) -> NSAttributedString? {
        guard let html = html,
              let data = html.data(using: .utf8) else { return nil }
        
        do {
            let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            
            let attributedString = try NSAttributedString(data: data,
                                                          options: options,
                                                          documentAttributes: nil)
            
            return attributedString
        } catch {
            set(state: .error(
                AlertData(
                    title: "Error parsing HTML to Attributed String",
                    message: "Please try again later",
                    actionTitle: "Ok",
                    actionHandler: nil
                )
            ))
            
            return nil
        }
    }
    
}
