//
//  DetailPresenter.swift
//

import Foundation

//-----------------------------------------------------------------------
//  MARK: - Presenter Delegate
//-----------------------------------------------------------------------

protocol DetailPresenterDelegate: BasePresenterDelegate {}

//-----------------------------------------------------------------------
//  MARK: - Presenter
//-----------------------------------------------------------------------

final class DetailPresenter: BasePresenter {
    
    var delegate: DetailPresenterDelegate?
    
    init (delegate: DetailPresenterDelegate?) {
        self.delegate = delegate
        
        super.init()
    }
}
