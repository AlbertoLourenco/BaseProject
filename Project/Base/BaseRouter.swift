//
//  BaseRouter.swift
//

import UIKit

class BaseRouter {
    
    var viewController: UIViewController!
    var presentationStyles: Array<PresentationStyle> = []
    
    //-----------------------------------------------------------------------
    //  MARK: - Mount root view -
    //-----------------------------------------------------------------------
    
    func getRootView() -> UINavigationController {
        
        var navigationVC: UINavigationController!
        
        if let token = Session.get()?.token, !token.isEmpty {
            navigationVC = UINavigationController(rootViewController: ContainerRouter().viewController)
        }else{
            navigationVC = UINavigationController(rootViewController: LoginRouter().viewController)
        }
        
        return navigationVC
    }
    
    //-----------------------------------------------------------------------
    //  MARK: - Present views -
    //-----------------------------------------------------------------------
    
    func show() {
        
        presentationStyles.append(.push)
        
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func present(transition: UIModalTransitionStyle = .coverVertical, animated: Bool = true) {
        
        presentationStyles.append(.modal)
        
        viewController.modalTransitionStyle = transition
        
        if transition == .crossDissolve {
            
            viewController.modalPresentationStyle = .overFullScreen
            
            UIApplication.topViewController()?.present(viewController, animated: animated, completion: nil)
        }else{
            
            let navigationVC = UINavigationController(rootViewController: viewController)
            navigationVC.isNavigationBarHidden = false
            navigationVC.modalPresentationStyle = .fullScreen
            
            UIApplication.topViewController()?.present(navigationVC, animated: animated, completion: nil)
        }
    }
    
    //-----------------------------------------------------------------------
    //  MARK: - Dismiss views -
    //-----------------------------------------------------------------------
    
    func dismiss(animated: Bool = true) {
        
        if let lastTransition = presentationStyles.last {
            
            if lastTransition == .push {
                viewController.navigationController?.popViewController(animated: animated)
            }else{
                viewController.dismiss(animated: animated, completion: nil)
            }
            
            presentationStyles.removeLast()
        }
    }
    
    func closeAllViews(animated: Bool = true) {
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: animated, completion: nil)
    }
}

//-----------------------------------------------------------------------
//  MARK: - Show modules (calling routers) -
//-----------------------------------------------------------------------

extension BaseRouter {
    
    func showLogin() {
        LoginRouter().present()
    }
    
    func showForgotPassword() {
        ForgotPasswordRouter().show()
    }
    
    func showRegister() {
        RegisterRouter().show()
    }
    
    func showHome() {
        ContainerRouter().present()
    }
    
    func showDetail() {
        DetailRouter().show()
    }
}
