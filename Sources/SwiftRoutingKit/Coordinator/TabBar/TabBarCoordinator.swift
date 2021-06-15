//
//  BaseCoordinator.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 21.03.2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import UIKit
import Swinject

open class TabBarCoordinator: Coordinator, TabBarCoordinatorProtocol {
    
    public let router: TabBarRouterProtocol
    
    public init(router: TabBarRouterProtocol, resolver: Resolver) {
        self.router = router
        super.init(resolver: resolver)
        router.tabBarController.delegate = self
    }
    
    public func setFlows(_ coordinators: [NavigationCoordinatorProtocol], initialIndex: Int) {
        childCoordinators = coordinators
        let scenes = coordinators.compactMap({ $0.router.navigationController })
        router.set(scenes)
        router.tabBarController.selectedIndex = initialIndex
        coordinators[initialIndex].start()
    }
    
    public var selectedCoordinator: CoordinatorProtocol {
        return childCoordinators[router.tabBarController.selectedIndex]
    }
    
    public func selectFirst<T: CoordinatorProtocol>(of: T.Type) {
        if let index = childCoordinators.firstIndex(where: { $0 is T }) {
            router.tabBarController.selectedIndex = index
            startCoorinatorForSelectedIndexIfNeeded()
        }
    }

    public func startCoorinatorForSelectedIndexIfNeeded() {
        if let coordinator = self.childCoordinators[router.tabBarController.selectedIndex] as? NavigationCoordinator,
            coordinator.router.navigationController.viewControllers.isEmpty {
            coordinator.start()
        }
    }
    
}

extension TabBarCoordinator: UITabBarControllerDelegate {
 
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        startCoorinatorForSelectedIndexIfNeeded()
    }
    
}
