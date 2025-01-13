//
//  File.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 13.01.2025.
//

import Foundation

public protocol Routable {
    
    associatedtype R = RouterProtocol
    
    var router: R { get }
    
}
