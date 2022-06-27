//
//  ForgotPasswordPresenter.swift
//

import UIKit

//-----------------------------------------------------------------------
//	MARK: - Presenter Delegate -
//-----------------------------------------------------------------------

protocol ForgotPasswordPresenterDelegate: BasePresenterDelegate {}

//-----------------------------------------------------------------------
//	MARK: - Presenter -
//-----------------------------------------------------------------------

final class ForgotPasswordPresenter: BasePresenter {
	
	var delegate: ForgotPasswordPresenterDelegate?
	
	init (delegate: ForgotPasswordPresenterDelegate?) {
		self.delegate = delegate
		
		super.init()
	}
    
	func recoverPassword(email: String?) {
		
        guard let validatedEmail = email, !validatedEmail.isEmpty, validatedEmail.isValidEmail else {
            Util.showMessage(message: Constants.Messages.InvalidEmail, type: .warning)
            return
        }
        
        self.delegate?.loading(true)
        
		Auth.recoverPassword(email: validatedEmail) { success in
            
            self.delegate?.loading(false)
            
			if success {
                self.closeView()
                Util.showMessage(message: Constants.Messages.EmailSentSuccess, type: .success)
			}else{
                Util.showMessage(message: Constants.Messages.UnknowError, type: .error)
			}
		}
	}
}
