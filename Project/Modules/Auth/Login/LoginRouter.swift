//
//  LoginRouter.swift
//

import UIKit

final class LoginRouter: BaseRouter {
	
    let storyboard = UIStoryboard(name: "Login", bundle: nil)
    
    override init() {
        super.init()
        
        if let controller = storyboard.instantiateViewController(withIdentifier: "LoginView") as? LoginViewController {

            let presenter = LoginPresenter(delegate: controller)
            
            controller.presenter = presenter
            controller.presenter.view = controller
            controller.presenter.router = self
            
            super.viewController = controller
        }
    }
}
