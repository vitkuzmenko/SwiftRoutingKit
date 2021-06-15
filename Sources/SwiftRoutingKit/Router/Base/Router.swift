//
//  Router.swift
//  Switips
//
//  Created by Vitaliy Kuzmenko on 21.03.2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import UIKit

open class Router: NSObject, RouterProtocol {
    
    open var modalPresentationStyle: UIModalPresentationStyle {
        get { return rootViewController.modalPresentationStyle }
        set { rootViewController.modalPresentationStyle = newValue }
    }
    
    open var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        get { return rootViewController.transitioningDelegate }
        set { rootViewController.transitioningDelegate = newValue }
    }
    
    let rootViewController: UIViewController
    
    open var window: UIWindow?
    
    init(rootViewController: UIViewController, window: UIWindow?) {
        self.rootViewController = rootViewController
        self.window = window
    }
    
    open func toScene() -> UIViewController {
        return rootViewController
    }
    
    open func present(_ scene: Scene?, animated: Bool) {
        guard let controller = scene?.toScene() else { return }
        rootViewController.present(controller, animated: animated, completion: nil)
    }
    
    open func dismiss(animated: Bool, completion: (() -> Void)?) {
        rootViewController.dismiss(animated: animated, completion: completion)
    }
    
    open func makeKeyIfNeeded() {
        if window?.rootViewController != rootViewController {
            window?.rootViewController = rootViewController
        }
    }
    
}
