//
//  AppDelegate.swift
//
//  Created by Александр on 14.02.2025.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import Router

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        let newsCategoriesAssembly = NewsCategoriesAssemblyImpl(navigationController: navigationController)
        let newsCategoriesViewController = newsCategoriesAssembly.assembly()
        navigationController.viewControllers = [newsCategoriesViewController]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

