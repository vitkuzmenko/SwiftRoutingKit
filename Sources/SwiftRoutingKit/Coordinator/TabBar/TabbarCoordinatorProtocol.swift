//
//  Coordinator.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 21.03.2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import Foundation

public protocol TabBarCoordinatorProtocol: CoordinatorProtocol, Routable {
    
    var router: TabBarRouterProtocol { get }
    
    func setFlows(_ coordinators: [any NavigationCoordinatorProtocol], initialIndex: Int)
    
}
