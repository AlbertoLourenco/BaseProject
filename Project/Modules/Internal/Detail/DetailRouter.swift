//
//  DetailRouter.swift
//

import UIKit

final class DetailRouter: BaseRouter {
    
    let storyboard = UIStoryboard(name: "Detail", bundle: nil)
    
    override init() {
        super.init()
        
        if let controller = storyboard.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController {

            let presenter = DetailPresenter(delegate: controller)
            
            controller.presenter = presenter
            controller.presenter.view = controller
            controller.presenter.router = self
            
            super.viewController = controller
        }
    }
}
