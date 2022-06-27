//
//  ForgotPasswordRouter.swift
//

import UIKit

final class ForgotPasswordRouter: BaseRouter {
	
    let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
    
    override init() {
        super.init()
        
        if let controller = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordView") as? ForgotPasswordViewController {

            let presenter = ForgotPasswordPresenter(delegate: controller)
            
            controller.presenter = presenter
            controller.presenter.view = controller
            controller.presenter.router = self
            
            super.viewController = controller
        }
    }
}
