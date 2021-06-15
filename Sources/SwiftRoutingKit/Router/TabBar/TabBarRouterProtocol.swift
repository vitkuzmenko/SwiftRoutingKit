//
//  NavigationRouterProtocol.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 21/02/2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import UIKit

public protocol TabBarRouterProtocol: RouterProtocol {
    
    var tabBarController: UITabBarController { get }
    
    func set(_ scenes: [Scene])
    
}
