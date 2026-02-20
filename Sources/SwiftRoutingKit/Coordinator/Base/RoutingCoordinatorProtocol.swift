//
//  Coordinator.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 21.03.2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import Foundation
import Swinject

public protocol RoutingCoordinatorProtocol: AnyObject {
    
    var resolver: Resolver { get }
    
    func start()
    
    func addChild(_ coordinator: RoutingCoordinator?)
    
    func child<T: RoutingCoordinator>(for type: T.Type) -> T?
    
    func removeChild(_ coordinator: RoutingCoordinator?)
    
}
