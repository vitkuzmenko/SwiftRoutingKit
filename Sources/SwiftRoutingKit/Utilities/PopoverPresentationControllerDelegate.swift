//
//  PopoverPresentationControllerDelegate.swift
//  SwiftRoutingKit
//
//  Created by Vitaliy Kuzmenko on 24.06.2021.
//  Copyright © 2021 Avatar Lab. All rights reserved.
//

import UIKit

public final class PopoverPresentationControllerDelegate: NSObject {
    
}

extension PopoverPresentationControllerDelegate: UIPopoverPresentationControllerDelegate {
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
}
