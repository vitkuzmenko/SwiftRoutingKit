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

open class TabBarCoordinator: RoutingCoordinator, TabBarCoordinatorProtocol {
    
    public let router: TabBarRouterProtocol
    
    public var childTabCoordinators: [RoutingCoordinatorProtocol] = []
    
    public init(router: TabBarRouterProtocol, resolver: Resolver) {
        self.router = router
        super.init(resolver: resolver)
        router.tabBarController.delegate = self
    }
    
    public func setFlows(_ coordinators: [NavigationCoordinatorProtocol], initialIndex: Int) {
        childTabCoordinators = coordinators
        let scenes = coordinators.compactMap({ $0.router.navigationController })
        router.set(scenes)
        router.tabBarController.selectedIndex = initialIndex
        coordinators[initialIndex].start()
    }
    
    public var selectedCoordinator: RoutingCoordinatorProtocol {
        return childTabCoordinators[router.tabBarController.selectedIndex]
    }
    
    public func selectFirst<T: RoutingCoordinatorProtocol>(of: T.Type, start: Bool = true) {
        guard let index = childTabCoordinators.firstIndex(where: { $0 is T }) else {
            return
        }
        selectTab(at: index, start: start)
    }

    /// Selects a tab programmatically without re-entrant KVO on `selectedIndex`.
    ///
    /// Setting `selectedIndex` synchronously inside animation completion handlers can corrupt
    /// Foundation's KVO lock (`_NSSetUnsignedLongLongValueAndNotify`). Deferring the
    /// assignment to the next main run loop avoids that crash.
    private func selectTab(at index: Int, start: Bool) {
        if router.tabBarController.selectedIndex == index {
            if start {
                startCoorinatorForSelectedIndexIfNeeded()
            }
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard index < self.childTabCoordinators.count else { return }
            self.router.tabBarController.selectedIndex = index
            if start {
                self.startCoorinatorForSelectedIndexIfNeeded()
            }
        }
    }
    
    public func getFirst<T: RoutingCoordinatorProtocol>(of: T.Type) -> T? {
        if let index = childTabCoordinators.firstIndex(where: { $0 is T }) {
            return childTabCoordinators[index] as? T
        } else {
            return nil
        }
    }

    public func startCoorinatorForSelectedIndexIfNeeded() {
//        router.tabBarController.selectedIndex = router.tabBarController.selectedIndex
        if
            let coordinator = self.childTabCoordinators[router.tabBarController.selectedIndex] as? NavigationCoordinator
        {
            if coordinator.router.navigationController.viewControllers.isEmpty {
                coordinator.start()
            } else {
                coordinator.impact()
            }
        }
    }
    
    public func present(_ scene: (any Scene)?) {
        router.present(scene)
    }
    
    public func present(_ scene: (any Scene)?, animated: Bool) {
        router.present(scene, animated: animated)
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
