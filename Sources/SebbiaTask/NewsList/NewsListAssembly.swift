//
//  NewsListAssembly.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 07.07.2025.
//

import Foundation
import UIKit
import Router

protocol NewsListAssembly: AnyObject {
    func assembly(id: Int) -> UIViewController
}

final class NewsListAssemblyImpl: NewsListAssembly {
    
    // MARK: - Private properties
    
    private var router: RouterProtocol
    
    // MARK: - Life cycle
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    // MARK: - Public methods
    
    func assembly(id: Int) -> UIViewController {
        let viewModel = NewsDIContainer.shared.makeNewsListViewModel(id: id)
        let viewController = NewsListViewController(viewModel: viewModel, router: router)
        
        return viewController
    }
    
}
