//
//  <#moduleName#>Presenter.swift
//

import Foundation

//-----------------------------------------------------------------------
//  MARK: - Presenter Delegate -
//-----------------------------------------------------------------------

protocol <#moduleName#>PresenterDelegate: BasePresenterDelegate {
    func loadedData()
}

//-----------------------------------------------------------------------
//  MARK: - Presenter -
//-----------------------------------------------------------------------

final class <#moduleName#>Presenter: BasePresenter {
    
    var delegate: <#moduleName#>PresenterDelegate?
    
    init(delegate: <#moduleName#>PresenterDelegate?) {
        self.delegate = delegate
        
        super.init()
    }
}
