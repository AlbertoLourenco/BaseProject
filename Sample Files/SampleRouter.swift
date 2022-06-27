//
//  <#moduleName#>Router.swift
//

import UIKit

final class <#moduleName#>Router: BaseRouter {
    
    let storyboard = UIStoryboard(name: "<#storyboardName#>", bundle: nil)
    
    override init() {
        super.init()
        
        if let controller = storyboard.instantiateViewController(withIdentifier: "<#viewId#>") as? <#moduleName#>ViewController {
            
            let presenter = <#moduleName#>Presenter(delegate: controller)
            controller.presenter = presenter
            controller.presenter.view = viewController
            controller.presenter.router = self
            
            viewController = controller
        }
    }
}
