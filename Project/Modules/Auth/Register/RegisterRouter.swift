//
//  RegisterRouter.swift
//

import UIKit

final class RegisterRouter: BaseRouter {
    
    let storyboard = UIStoryboard(name: "Register", bundle: nil)
    
    override init() {
        super.init()
        
        if let controller = storyboard.instantiateViewController(withIdentifier: "RegisterView") as? RegisterViewController {

            let presenter = RegisterPresenter(delegate: controller)
            
            controller.presenter = presenter
            controller.presenter.view = controller
            controller.presenter.router = self
            
            super.viewController = controller
        }
    }
}
