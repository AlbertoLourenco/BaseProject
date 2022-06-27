//
//  ContainerRouter.swift
//

import UIKit

final class ContainerRouter: BaseRouter {
	
    let storyboard = UIStoryboard(name: "Container", bundle: nil)
    
    override init() {
        super.init()
        
        if let controller = storyboard.instantiateViewController(withIdentifier: "ContainerView") as? ContainerViewController {
            super.viewController = controller
        }
    }
}
