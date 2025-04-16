//
//  Router.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 21.03.2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import UIKit

public final class NavigationRouter: Router, NavigationRouterProtocol, UIPopoverPresentationControllerDelegate {
    
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
    
    public func cut(scene: (any Scene)?) {
        self.navigationController.viewControllers.removeAll { rhs in
            rhs === scene?.toScene()
        }
    }
    
    public func popScene(animated: Bool) {
        if let controller = navigationController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    @discardableResult
    public func popToScene(_ scene: (any Scene)?, animated: Bool) -> Bool {
        popToScene(scene, animated: animated, completion: nil)
    }
    
    @discardableResult
    public func popToScene(_ scene: (any Scene)?, animated: Bool, completion: (() -> Void)?) -> Bool {
        guard let viewController = navigationController.viewControllers.first(where: { $0 == scene?.toScene() }) else {
            return false
        }
        let popBlock = { [weak self] in
            self?.navigationController.popToViewController(viewController, animated: animated)
        }
        if animated, let completion {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            _ = popBlock()
            CATransaction.commit()
        } else {
            _ = popBlock()
            completion?()
        }
        return true
    }
    
    public func popToFirstScene<T>(animated: Bool) -> T? {
        popToFirstScene(animated: animated, completion: nil)
    }
    
    public func popToFirstScene<T>(animated: Bool, completion: ((T) -> Void)?) -> T? {
        guard let viewController = navigationController.viewControllers.first(where: { $0 is T }) else {
            return nil
        }
        guard let scene = viewController as? T else {
            return nil
        }
        popToScene(viewController, animated: animated) {
            completion?(scene)
        }
        return scene
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
    
    public func presentPopover(scene: Scene?, sourceView: UIView) {
        guard let vc = scene?.toScene() else { return }
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.sourceView = sourceView
        vc.popoverPresentationController?.sourceRect = sourceView.bounds
        vc.popoverPresentationController?.permittedArrowDirections = [.up, .down]
        vc.popoverPresentationController?.delegate = self
        navigationController.present(vc, animated: true)
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
}
