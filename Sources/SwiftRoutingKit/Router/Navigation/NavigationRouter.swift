//
//  Router.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 21.03.2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import UIKit

public final class NavigationRouter: Router, NavigationRouterProtocol {
    
    deinit {
        navigationController.viewControllers = []
    }
    
    private var completions: [UIViewController: () -> Void] = [:]
    
    public var navigationController: UINavigationController {
        return rootViewController as! UINavigationController
    }
    
    public var topScene: Scene? {
        return navigationController.topViewController
    }
    
    public var rootScene: Scene? {
        return navigationController.viewControllers.first
    }
    
    public init(navigationController: UINavigationController, window: UIWindow?) {
        super.init(rootViewController: navigationController, window: window)
    }
    
    override init(rootViewController: UIViewController, window: UIWindow?) {
        fatalError("Use init(tabBarController: UITabBarController, window: UIWindow?)")
    }
    
    public func push(_ scene: Scene?, animated: Bool, completion: (() -> Void)?) {
        guard let controller = scene?.toScene(), controller is UINavigationController == false else {
            fatalError("Scene can not be nil or UINavigationController. Check for assembly.")
        }
        if let completion = completion {
            completions[controller] = completion
        }
        navigationController.pushViewController(controller, animated: animated)
    }
    
    public func cut(fromScene: Scene?, toScene: Scene?) {
        let vcs = self.navigationController.viewControllers
        var isCut = false
        for vc in vcs {
            if vc === vcs.last {
                break
            } else if isCut {
                self.navigationController.viewControllers.removeAll(where: { $0 === vc })
            } else if vc == fromScene?.toScene() {
                isCut = true
            }
        }
    }
    
    public func popScene(animated: Bool) {
        if let controller = navigationController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    public func popToScene(_ scene: Scene?, animated: Bool) {
        guard let viewController = navigationController.viewControllers.first(where: { $0 == scene?.toScene() }) else {
            return
        }
        navigationController.popToViewController(viewController, animated: animated)
    }
    
    public func setRootScene(_ scene: Scene?, hideBar: Bool) {
        guard let controller = scene?.toScene() else {
            fatalError("Scene cannot be nil")
        }
        navigationController.viewControllers = [controller]
        navigationController.isNavigationBarHidden = hideBar
    }
    
    public func setScenes(_ scene: [Scene]) {
        let vcs = scene.map({ $0.toScene() })
        navigationController.viewControllers = vcs
    }
    
    public func popToRootScene(animated: Bool) {
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
    
}
