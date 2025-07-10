//
//  NewsCategoriesAssembly.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 07.07.2025.
//

import Foundation
import UIKit
import Router

protocol NewsCategoriesAssembly: AnyObject {
    func assembly() -> UIViewController
}

final class NewsCategoriesAssemblyImpl: NewsCategoriesAssembly {
    
    // MARK: - Private properties
    
    private var navigationController: UINavigationController
    
    // MARK: - Life cycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public methods
    
    func assembly() -> UIViewController {
        let router = Router(navigationController: navigationController)
        let viewModel = NewsDIContainer.shared.newsCategoriesViewModel
        let viewController = NewsCategoriesViewController(viewModel: viewModel, router: router)
        
        return viewController
    }
    
}
