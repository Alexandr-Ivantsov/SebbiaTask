//
//  NewsCategoriesUseCase.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 24.06.2025.
//

import Foundation
import CacheManagerWithoutKeychain
import RxSwift

protocol NewsCategoriesUseCase: AnyObject {
    func getCategories() -> Single<NewsCategory>
}

final class NewsCategoriesUseCaseImpl: NewsCategoriesUseCase {
    
    // MARK: - Private properties
    
    private let repository: NewsCategoriesRepository
    private let cacheUseCase: CacheUseCase
    private let newsCategoriesKey = "newsCategories"
    
    // MARK: - Life cycle
    
    init(repository: NewsCategoriesRepository, cacheUseCase: CacheUseCase) {
        self.repository = repository
        self.cacheUseCase = cacheUseCase
    }
    
    // MARK: - Public methods
    
    func getCategories() -> Single<NewsCategory> {
        if let cachedData: NewsCategory? = try? cacheUseCase.load(from: newsCategoriesKey),
           let data = cachedData {
            return Single.just(data)
        }
        
        return repository.getCategories()
            .flatMap{ [weak self] categories -> Single<NewsCategory> in
                guard let self else { return Single.just(categories) }
                
                do {
                    try self.cacheUseCase.save(data: categories, for: newsCategoriesKey)
                } catch {
                    print(#file, "Failed to save data to cache")
                }
                return Single.just(categories)
            }
    }
    
    
}
