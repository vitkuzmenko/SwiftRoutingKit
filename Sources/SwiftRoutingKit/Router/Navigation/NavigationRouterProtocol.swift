//
//  NavigationRouterProtocol.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 21/02/2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import UIKit

public enum NavigationRouterPresentaionMode {
    case root(hideNavigationBar: Bool), push(animated: Bool), present(animated: Bool)
}

public protocol NavigationRouterProtocol: RouterProtocol {
    
    var navigationController: UINavigationController { get }
    
    var topScene: Scene? { get }
    var rootScene: Scene? { get }
    
    func push(_ scene: Scene?)
    func push(_ scene: Scene?, animated: Bool)
    func push(_ scene: Scene?, animated: Bool, completion: (() -> Void)?)
    
    func cut(fromScene: Scene?, toScene: Scene?)
    
    func popScene()
    func popScene(animated: Bool)
    
    @discardableResult
    func popToScene(_ scene: Scene?, animated: Bool) -> Bool
    @discardableResult
    func popToScene(_ scene: Scene?, animated: Bool, completion: (() -> Void)?) -> Bool
    
    @discardableResult
    func popToFirstScene<T: Scene>(_ scene: T.Type, animated: Bool) -> T?
    @discardableResult
    func popToFirstScene<T: Scene>(_ scene: T.Type, animated: Bool, completion: ((T) -> Void)?) -> T?
    
    func popToRootScene(animated: Bool)
    
    func setRootScene(_ scene: Scene?)
    func setRootScene(_ scene: Scene?, hideBar: Bool)
    func setScenes(_ scene: [Scene])
    
    func show(scene: Scene?, mode: NavigationRouterPresentaionMode)
    
}

extension NavigationRouterProtocol {
    
    public func push(_ scene: Scene?) {
        push(scene, animated: true)
    }
    
    public func push(_ scene: Scene?, animated: Bool) {
        push(scene, animated: animated, completion: nil)
    }
    
    public func popScene() {
        popScene(animated: true)
    }
    
    public func setRootScene(_ scene: Scene?) {
        setRootScene(scene, hideBar: false)
    }
    
    public func show(scene: Scene?, mode: NavigationRouterPresentaionMode) {
        switch mode {
        case let .root(hideNavigationBar):
            setRootScene(scene, hideBar: hideNavigationBar)
        case let .push(animated):
            push(scene, animated: animated)
        case let .present(animated):
            present(scene, animated: animated)
        }
    }
    
}
