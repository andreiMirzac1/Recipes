//
//  AppDelegate.swift
//  Recipes
//
//  Created by Andrei Mirzac on 13/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let container = DependencyContainer()
        let viewController = container.makeRecipesViewController()
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()

        URLCache.configureSharedURLCache(memoryCapacityInMb: 0, diskCapacityInMb: 30)

        return true
    }
}

