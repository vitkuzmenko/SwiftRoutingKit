//
//  Coordinator.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 21.03.2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import Foundation

public protocol NavigationCoordinatorProtocol: CoordinatorProtocol, Scene {
    
    var router: NavigationRouterProtocol { get }
    
}
