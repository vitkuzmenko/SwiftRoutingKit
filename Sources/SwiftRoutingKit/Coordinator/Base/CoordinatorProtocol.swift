//
//  Coordinator.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 21.03.2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import Foundation
import Swinject

public protocol CoordinatorProtocol: AnyObject {
    
    var resolver: Resolver { get }
    
    func start()
    
    func addChild(_ coordinator: Coordinator?)
    
    func child<T: Coordinator>(for type: T.Type) -> T?
    
    func removeChild(_ coordinator: Coordinator?)
    
}
