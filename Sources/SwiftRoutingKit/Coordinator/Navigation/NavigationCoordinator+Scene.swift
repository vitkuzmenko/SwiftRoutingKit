//
//  NavigationCoordinator+Scene.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 02.09.2020.
//  Copyright © 2020 Avatar Lab. All rights reserved.
//

import UIKit

extension NavigationCoordinator {
    
    public var modalPresentationStyle: UIModalPresentationStyle {
        set {
            router.navigationController.modalPresentationStyle = newValue
        }
        get {
            return router.navigationController.modalPresentationStyle
        }
    }
    
    public var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        set {
            router.transitioningDelegate = newValue
        }
        get {
            return router.navigationController.transitioningDelegate
        }
    }
    
    public func toScene() -> UIViewController {
        start()
        return router.navigationController
    }
    
    public func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        router.navigationController.dismiss(animated: flag, completion: completion)
    }
    
}
