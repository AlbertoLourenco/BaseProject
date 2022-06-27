//
//  HomeRouter.swift
//

import UIKit

final class HomeRouter: BaseRouter {
    
    let storyboard = UIStoryboard(name: "Home", bundle: nil)
    
    override init() {
        super.init()
        
        if let controller = storyboard.instantiateViewController(withIdentifier: "HomeView") as? HomeViewController {
            
            let presenter = HomePresenter(delegate: controller)
            
            controller.presenter = presenter
            controller.presenter.view = controller
            controller.presenter.router = self
            
            super.viewController = controller
        }
    }
}
