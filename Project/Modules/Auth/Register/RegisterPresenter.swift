//
//  RegisterPresenter.swift
//

import Foundation

//-----------------------------------------------------------------------
//  MARK: - Presenter Delegate -
//-----------------------------------------------------------------------

protocol RegisterPresenterDelegate: BasePresenterDelegate {}

//-----------------------------------------------------------------------
//  MARK: - Presenter -
//-----------------------------------------------------------------------

final class RegisterPresenter: BasePresenter {
    
    var delegate: RegisterPresenterDelegate?
    
    init (delegate: RegisterPresenterDelegate?) {
        self.delegate = delegate
        
        super.init()
    }
    
    func register(name: String?, email: String?, password: String?, passwordConfirmation: String?) {
        
        guard let filledName = name else {
            Util.showMessage(message: Constants.Messages.FillRequiredFields, type: .warning)
            return
        }
        
        guard let filledEmail = email else {
            Util.showMessage(message: Constants.Messages.FillRequiredFields, type: .warning)
            return
        }
        
        guard filledEmail.isValidEmail else {
            Util.showMessage(message: Constants.Messages.InvalidEmail, type: .warning)
            return
        }
        
        guard let filledPassword = password else {
            Util.showMessage(message: Constants.Messages.FillRequiredFields, type: .warning)
            return
        }
        
        guard let filledPasswordConfirmation = passwordConfirmation else {
            Util.showMessage(message: Constants.Messages.FillRequiredFields, type: .warning)
            return
        }
        
        guard filledPassword == filledPasswordConfirmation else {
            Util.showMessage(message: Constants.Messages.PasswordsNotMatch, type: .warning)
            return
        }
        
        var register = Register()
        register.name = filledName
        register.email = filledEmail
        register.password = filledPassword
        register.passwordConfirm = filledPasswordConfirmation
        
        self.delegate?.loading(true)
        
        Register.add(object: register) { result, error in
            
            self.delegate?.loading(false)
            
            if let data = result {
                
                Session.resetOffline()
                Session.set(auth: data)
                
                super.router.showHome()
            }else{
                Util.showMessage(message: error?.message, type: .warning)
            }
        }
    }
    
    private func showHome(auth: Auth) {
        Session.set(auth: auth)
        Reachability.shared = try! Reachability()
        super.router.showHome()
    }
}
