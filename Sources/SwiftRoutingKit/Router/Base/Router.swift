//
//  Router.swift
//  Switips
//
//  Created by Vitaliy Kuzmenko on 21.03.2019.
//  Copyright © 2019 Kuzmenko.info. All rights reserved.
//

import UIKit

open class Router: NSObject, RouterProtocol {
    
    open var modalPresentationStyle: UIModalPresentationStyle {
        get { return rootViewController.modalPresentationStyle }
        set { rootViewController.modalPresentationStyle = newValue }
    }
    
    open var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        get { return rootViewController.transitioningDelegate }
        set { rootViewController.transitioningDelegate = newValue }
    }
    
    let rootViewController: UIViewController
    
    open weak var window: UIWindow?
    
    init(rootViewController: UIViewController, window: UIWindow?) {
        self.rootViewController = rootViewController
        self.window = window
    }
    
    open func toScene() -> UIViewController {
        return rootViewController
    }
    
    open func present(_ scene: Scene?, animated: Bool) {
        guard let controller = scene?.toScene() else { return }
        if let presented = rootViewController.presentedViewController {
            presented.present(controller, animated: animated, completion: nil)
        } else {
            rootViewController.present(controller, animated: animated, completion: nil)
        }
    }
    
    open func dismiss(animated: Bool, completion: (() -> Void)?) {
        rootViewController.dismiss(animated: animated, completion: completion)
    }
    
    open func makeKeyIfNeeded() {
        if window?.rootViewController != rootViewController {
            window?.rootViewController = rootViewController
        }
    }
    
    open func makeKeyIfNeeded(animation: KeyAnimation) {
        switch animation {
        case .slideIn:
            makeKeyIfNeededWithSlideInAnimation()
        case .slideOut:
            makeKeyIfNeededWithSlideOutAnimation()
        }
    }
    
    private func makeKeyIfNeededWithSlideInAnimation() {
        guard let window = window else {
            return makeKeyIfNeeded()
        }
        
        let image = window.rootViewController!.view.srk_takeSnapshot()
        
        let imageView = UIImageView(image: image)
        imageView.frame = window.bounds
        
        window.addSubview(imageView)
        
        let backdrop = UIView(frame: window.bounds)
        backdrop.backgroundColor = .black
        backdrop.alpha = 0
        
        window.insertSubview(backdrop, aboveSubview: imageView)
        
        makeKeyIfNeeded()
        
        rootViewController.view.transform = .init(
            translationX: -window.bounds.width,
            y: .zero
        )
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 2,
            options: []
        ) {
            imageView.transform = CGAffineTransform(
                translationX: imageView.frame.width / 2,
                y: .zero
            )
            backdrop.alpha = 1
            self.rootViewController.view.transform = .identity
        } completion: { _ in
            imageView.removeFromSuperview()
            backdrop.removeFromSuperview()
        }
    }
    
    private func makeKeyIfNeededWithSlideOutAnimation() {
        guard let window = window else {
            return makeKeyIfNeeded()
        }
        
        let image = window.rootViewController!.view.srk_takeSnapshot()
        
        let imageView = UIImageView(image: image)
        imageView.frame = window.bounds
        
        window.addSubview(imageView)
        
        makeKeyIfNeeded()
        
        window.bringSubviewToFront(imageView)
        
        let backdrop = UIView(frame: window.bounds)
        backdrop.backgroundColor = .black
        
        window.insertSubview(backdrop, belowSubview: imageView)
        
        rootViewController.view.transform = .init(
            translationX: window.bounds.width / 2,
            y: .zero
        )
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 2,
            options: []
        ) {
            imageView.transform = CGAffineTransform(
                translationX: -imageView.frame.width,
                y: .zero
            )
            backdrop.alpha = 0
            self.rootViewController.view.transform = .identity
        } completion: { _ in
            imageView.removeFromSuperview()
            backdrop.removeFromSuperview()
        }
    }
    
}

extension UIView {

    fileprivate func srk_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

