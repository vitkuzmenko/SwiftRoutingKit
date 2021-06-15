//
//  BaseCoordinator.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 21.03.2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import Foundation
import Swinject

open class Coordinator: NSObject, CoordinatorProtocol {
    
    open var childCoordinators: [CoordinatorProtocol] = []
    
    public let resolver: Resolver
    
    public init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    open func start() {
        
    }
    
    open func addChild(_ coordinator: Coordinator?) {
        guard let coordinator = coordinator else { return }
        for element in childCoordinators where element === coordinator {
            return
        }
        childCoordinators.append(coordinator)
    }
    
    open func child<T: Coordinator>(for type: T.Type) -> T? {
        return childCoordinators.first(where: { $0 is T }) as? T
    }
    
    open func removeChild(_ coordinator: Coordinator?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }
        for (index, element) in childCoordinators.reversed().enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}
