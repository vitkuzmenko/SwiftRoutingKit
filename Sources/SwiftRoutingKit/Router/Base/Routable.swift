//
//  File.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 13.01.2025.
//

import Foundation

public protocol Presentable {
    
    func present(_ scene: Scene?)
    func present(_ scene: Scene?, animated: Bool)
    
}
