//
//  Scene.swift
//  Switips
//
//  Created by Vitaliy Kuzmenko on 21.03.2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import UIKit

extension NSObject {
    
    fileprivate var nameOfClass: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
}

public protocol Scene: AnyObject {
    var modalPresentationStyle: UIModalPresentationStyle { get set }
    var transitioningDelegate: UIViewControllerTransitioningDelegate? { get set }
    func toScene() -> UIViewController
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}

public protocol ParentalScene: Scene {
    func superviewForChildSceneView(for identifier: String) -> UIView?
}

public protocol ChildScene: Scene {
    var sceneIdentifier: String { get }
}

extension UIViewController: Scene {
    
    public func toScene() -> UIViewController {
        return self
    }
    
}

extension ParentalScene where Self: UIViewController {
    
    public func register(scene: ChildScene) {
        guard let view = superviewForChildSceneView(for: scene.sceneIdentifier) else {
            return assertionFailure("need view for scene \(scene.toScene().nameOfClass)")
        }
        view.addSubview(scene.toScene().view)
        addChild(scene.toScene())
    }
    
}


extension UIViewController: ChildScene {
 
    public var sceneIdentifier: String {
        return nameOfClass
    }
    
}
