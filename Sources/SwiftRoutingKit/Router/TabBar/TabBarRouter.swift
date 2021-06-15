//
//  Router.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 21.03.2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import UIKit

public final class TabBarRouter: Router, TabBarRouterProtocol {
    
    private var completions: [UIViewController: () -> Void] = [:]
    
    public var tabBarController: UITabBarController {
        return rootViewController as! UITabBarController
    }
    
    public init(tabBarController: UITabBarController, window: UIWindow?) {
        super.init(rootViewController: tabBarController, window: window)
    }
    
    override public init(rootViewController: UIViewController, window: UIWindow?) {
        fatalError("Use init(tabBarController: UITabBarController, window: UIWindow?)")
    }
    
    public func set(_ scenes: [Scene]) {
        tabBarController.viewControllers = scenes.compactMap({ $0.toScene() })
    }
    
}
