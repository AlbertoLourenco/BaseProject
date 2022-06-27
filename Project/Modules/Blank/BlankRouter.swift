//
//  BlankRouter.swift
//

import UIKit

final class BlankRouter: BaseRouter {
    
    let storyboard = UIStoryboard(name: "Blank", bundle: nil)
    
    override init() {
        super.init()
        
        if let controller = storyboard.instantiateViewController(withIdentifier: "BlankView") as? BlankViewController {
            super.viewController = controller
        }
    }
}
