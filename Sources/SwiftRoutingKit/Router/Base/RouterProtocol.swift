//
//  RouterProtocol.swift
//  Switips
//
//  Created by Vitaliy Kuzmenko on 21.03.2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import UIKit

public enum KeyAnimation {
    case slideIn
    case slideOut
}

public protocol RouterProtocol: Scene {
    
    var window: UIWindow? { get }
    
    func present(_ scene: Scene?)
    func present(_ scene: Scene?, animated: Bool)

    func dismiss()
    func dismiss(animated: Bool, completion: (() -> Void)?)
    
    func makeKeyIfNeeded()
    func makeKeyIfNeeded(animation: KeyAnimation)
    
}


extension RouterProtocol {
    
    public func present(_ scene: Scene?) {
        present(scene, animated: true)
    }
    
    public func dismiss() {
        dismiss(animated: true, completion: nil)
    }
        
}
