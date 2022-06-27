//
//  BasePresenter.swift
//

import UIKit

//-----------------------------------------------------------------------
//  MARK: - Presenter Delegate -
//-----------------------------------------------------------------------

protocol BasePresenterDelegate {
    func loading(_ loading: Bool)
}

//  Making methods optionals

extension BasePresenterDelegate {
    func loading(_ loading: Bool) {}
}

//-----------------------------------------------------------------------
//  MARK: - Presenter -
//-----------------------------------------------------------------------

class BasePresenter {
    
    var view: UIViewController!
    var router: BaseRouter!
    
    func closeView(animated: Bool = true) {
        DispatchQueue.main.async {
            self.router.dismiss(animated: animated)
        }
    }
}
