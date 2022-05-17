//
//  BaseCoordinator.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 21.03.2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import Foundation
import Swinject
import UIKit

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
    
    public func selectFirst<T: CoordinatorProtocol>(of: T.Type, start: Bool = true) {
        if let index = childCoordinators.firstIndex(where: { $0 is T }) {
            router.tabBarController.selectedIndex = index
            if start {
                startCoorinatorForSelectedIndexIfNeeded()
            }
        }
    }
    
    public func getFirst<T: CoordinatorProtocol>(of: T.Type) -> T? {
        if let index = childCoordinators.firstIndex(where: { $0 is T }) {
            return childCoordinators[index] as? T
        } else {
            return nil
        }
    }

    public func startCoorinatorForSelectedIndexIfNeeded() {
        router.tabBarController.selectedIndex = router.tabBarController.selectedIndex
        if let coordinator = self.childCoordinators[router.tabBarController.selectedIndex] as? NavigationCoordinator,
            coordinator.router.navigationController.viewControllers.isEmpty {
            coordinator.start()
        }
    }
    
}

extension TabBarCoordinator: UITabBarControllerDelegate {
 
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        startCoorinatorForSelectedIndexIfNeeded()
        if let delegate = router.tabBarController as? UITabBarControllerDelegate {
            delegate.tabBarController?(tabBarController, didSelect: viewController)
        }
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let delegate = router.tabBarController as? UITabBarControllerDelegate, let value = delegate.tabBarController?(tabBarController, shouldSelect: viewController) {
            return value
        }
        return true
    }
    
}
