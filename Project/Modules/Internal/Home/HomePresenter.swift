//
//  HomePresenter.swift
//

import Foundation

//-----------------------------------------------------------------------
//  MARK: - Presenter Delegate
//-----------------------------------------------------------------------

protocol HomePresenterDelegate: BasePresenterDelegate {}

//-----------------------------------------------------------------------
//  MARK: - Presenter
//-----------------------------------------------------------------------

final class HomePresenter: BasePresenter {
    
    var delegate: HomePresenterDelegate?
    
    init (delegate: HomePresenterDelegate?) {
        self.delegate = delegate
        
        super.init()
    }
    
    func logout() {
        Session.logout()
        super.router.showLogin()
    }
}
