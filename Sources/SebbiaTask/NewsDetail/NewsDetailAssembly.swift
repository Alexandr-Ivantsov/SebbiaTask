//
//  NewsDetailAssembly.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 10.07.2025.
//

import Foundation
import UIKit
import Router

protocol NewsDetailAssembly: AnyObject {
    func assembly(id: Int, newsListItem: NewsListItem) -> UIViewController
}

final class NewsDetailAssemblyImpl: NewsDetailAssembly {
    
    // MARK: - Public methods
    
    func assembly(id: Int, newsListItem: NewsListItem) -> UIViewController {
        let viewModel = NewsDIContainer.shared.makeNewsDetailViewModel(id: id)
        let viewController = NewsDetailViewController(viewModel: viewModel, newsListItem: newsListItem)
        
        return viewController
    }
    
}
