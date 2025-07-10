//
//  NewsCategoriesRepository.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 24.06.2025.
//

import Foundation
import Moya
import RxSwift
import RxMoya

protocol NewsCategoriesRepository: AnyObject {
    func getCategories() -> Single<NewsCategory>
}

final class NewsCategoriesRepositoryImpl: NewsCategoriesRepository {
    
    // MARK: - Private properties
    
    private let provider = MoyaProvider<NewsAPI>()
    
    // MARK: - Public methods
    
    func getCategories() -> Single<NewsCategory> {
        return provider.rx.request(NewsAPI.getCategories)
            .filterSuccessfulStatusCodes()
            .map(NewsCategory.self)
    }
    
}
