//
//  BaseCoordinator.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 21.03.2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import UIKit
import Swinject

open class NavigationCoordinator: Coordinator, NavigationCoordinatorProtocol, Routable {
    
    public let router: NavigationRouterProtocol
    
    public var flowDidDismiss: (() -> Void)? = nil
    
    public init(router: NavigationRouterProtocol, resolver: Resolver) {
        self.router = router
        super.init(resolver: resolver)
        router.navigationController.presentationController?.delegate = self
    }

}

extension NavigationCoordinator: UIAdaptivePresentationControllerDelegate {
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        flowDidDismiss?()
    }
    
}
