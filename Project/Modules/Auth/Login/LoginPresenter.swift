//
//  LoginPresenter.swift
//

import Foundation

//-----------------------------------------------------------------------
//	MARK: - Presenter Delegate -
//-----------------------------------------------------------------------

protocol LoginPresenterDelegate: BasePresenterDelegate {}

//-----------------------------------------------------------------------
//	MARK: - Presenter -
//-----------------------------------------------------------------------

final class LoginPresenter: BasePresenter {
	
	var delegate: LoginPresenterDelegate?
    
	init (delegate: LoginPresenterDelegate?) {
		self.delegate = delegate
		
		super.init()
	}
	
    func makeLogin(email: String?, password: String?) {
        
#if DEBUG
        self.showHome(auth: Auth())
#else
        guard let validatedEmail = email, !validatedEmail.isEmpty, validatedEmail.isValidEmail else {
            Util.showMessage(message: Constants.Messages.FillRequiredFields, type: .warning)
            return
        }
        
        guard let validatedPassword = password, !validatedPassword.isEmpty else {
            Util.showMessage(message: Constants.Messages.FillRequiredFields, type: .warning)
            return
        }
        
        self.delegate?.loading(true)

        Auth.login(email: validatedEmail,
                   password: validatedPassword) { result, error in

            self.delegate?.loading(false)

            if let data = result {
                self.showHome(auth: data)
            }else{
                Util.showMessage(message: error?.message, type: .warning)
            }
        }
#endif
    }
    
    private func showHome(auth: Auth) {
        
        Session.set(auth: auth)
        
        Reachability.shared = try! Reachability()
        
        super.router.showHome()
    }
}
