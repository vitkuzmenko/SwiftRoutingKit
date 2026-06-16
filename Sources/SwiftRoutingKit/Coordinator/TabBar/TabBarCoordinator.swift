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
        performProgrammaticTabSelection(at: initialIndex, start: false)
        guard coordinators.indices.contains(initialIndex) else { return }
        coordinators[initialIndex].start()
    }
    
    public var selectedCoordinator: RoutingCoordinatorProtocol {
        let index = router.tabBarController.selectedIndex
        return childTabCoordinators[index]
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
        DispatchQueue.main.async { [weak self] in
            self?.performProgrammaticTabSelection(at: index, start: start)
        }
    }

    private func performProgrammaticTabSelection(at index: Int, start: Bool) {
        guard
            let viewControllers = router.tabBarController.viewControllers,
            viewControllers.indices.contains(index)
        else {
            return
        }

        if router.tabBarController.selectedIndex == index {
            if start {
                startCoorinatorForSelectedIndexIfNeeded()
            }
            return
        }

        let tabBarController = router.tabBarController
        let previousDelegate = tabBarController.delegate
        tabBarController.delegate = nil
        tabBarController.selectedViewController = viewControllers[index]
        tabBarController.delegate = previousDelegate

        if start {
            startCoorinatorForSelectedIndexIfNeeded()
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
        let selectedIndex = router.tabBarController.selectedIndex
        guard childTabCoordinators.indices.contains(selectedIndex) else { return }
        if
            let coordinator = self.childTabCoordinators[selectedIndex] as? NavigationCoordinator
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
