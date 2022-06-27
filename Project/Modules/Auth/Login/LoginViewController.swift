//
//  LoginViewController.swift
//

import UIKit

final class LoginViewController: BaseViewController,
                                 LoginPresenterDelegate,
                                 UITextFieldDelegate {
    
	@IBOutlet private weak var vwBox: UIView!
	@IBOutlet private weak var vwLogin: UIView!
	@IBOutlet private weak var vwPassword: UIView!
	@IBOutlet private weak var svForm: UIScrollView!
	@IBOutlet private weak var txtLogin: UITextField!
	@IBOutlet private weak var txtPassword: UITextField!
	@IBOutlet private weak var btnLogin: UIButton!
	@IBOutlet private weak var btnRecoverPassword: UIButton!
    @IBOutlet private weak var btnRegister: UIButton!
	@IBOutlet private weak var actLoading: UIActivityIndicatorView!
	@IBOutlet private weak var lblVersion: UILabel!
	
	//-----------------------------------------------------------------------
	//	MARK: - UIViewController -
	//-----------------------------------------------------------------------
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.configUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
        
        self.loadUI()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
        NotificationCenter.default.removeObserver(self)
	}
    
    //-----------------------------------------------------------------------
    //  MARK: - BaseViewController -
    //-----------------------------------------------------------------------
    
    override func rotated() {
        // TO-DO
    }
    
    override func themeChanged() {
        // TO-DO
    }
    
	//-----------------------------------------------------------------------
	//	MARK: - Presenter Delegate -
	//-----------------------------------------------------------------------
    
    func loading(_ loading: Bool) {
        if loading {
            Util.showHUD()
        }else{
            Util.hideHUD()
        }
    }
    
    //-----------------------------------------------------------------------
    //  MARK: - UITextField Delegate -
    //-----------------------------------------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
    
	//-----------------------------------------------------------------------
	//	MARK: - Custom methods -
	//-----------------------------------------------------------------------
	
    private func configUI() {
        
        self.configKeyboard()
        
        self.navigationController?.navigationBar.isHidden = true
        
        if let info = Bundle.main.infoDictionary,
           let version = info["CFBundleShortVersionString"] as? String {
            self.lblVersion.text = "\(Constants.Strings.Version): \(version)"
        }
        
		self.vwLogin.layer.borderWidth = 1
		self.vwLogin.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
		self.vwLogin.layer.cornerRadius = 10
		
		self.vwPassword.layer.borderWidth = 1
		self.vwPassword.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
		self.vwPassword.layer.cornerRadius = 10
        
        Util.tintPlaceholder(field: self.txtLogin, color: UIColor.lightGray)
        Util.tintPlaceholder(field: self.txtPassword, color: UIColor.lightGray)
        
        self.btnRegister.titleLabel?.attributedText = self.btnRegister.currentTitle?.underline()
        self.btnRecoverPassword.titleLabel?.attributedText = self.btnRecoverPassword.currentTitle?.underline()
	}
    
    private func loadUI() {}
   
	@IBAction private func login() {
		
		self.hideKeyboard()
		
		(presenter as? LoginPresenter)?.makeLogin(email: self.txtLogin.text,
                                                  password: self.txtPassword.text)
	}
	
	@IBAction private func showForgotPassword() {
        presenter.router.showForgotPassword()
	}
	
    @IBAction private func showRegister() {
        presenter.router.showRegister()
    }
    
    @IBAction private func showHidePassword(_ sender: UIButton) {
        
        if self.txtPassword.isSecureTextEntry {
            sender.setImage(UIImage(named: "Login-Eye"), for: .normal)
        }else{
            sender.setImage(UIImage(named: "Login-Eye-Blocked"), for: .normal)
        }

        self.txtPassword.isSecureTextEntry = !self.txtPassword.isSecureTextEntry
    }
    
    //-----------------------------------------------------------------------
    //  MARK: - Keyboard -
    //-----------------------------------------------------------------------
    
    private func configKeyboard() {
		
		NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidAppear),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        
		NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
		
		let tapToHideKeyboard = UITapGestureRecognizer(target: self,
                                                       action: #selector(hideKeyboard))
		tapToHideKeyboard.numberOfTapsRequired = 1
		self.view.addGestureRecognizer(tapToHideKeyboard)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.svForm.contentSize = CGSize(width: UIScreen.shared.viewportWidth(),
                                              height: self.vwBox.frame.maxY)
		}
	}
	
	@objc private func hideKeyboard() {
		self.txtLogin.resignFirstResponder()
		self.txtPassword.resignFirstResponder()
	}
    
    @objc private func keyboardDidAppear(notification: Notification) {
        let screenSize = UIScreen.main.bounds.size
        if let keyboardFrame = (notification.userInfo as NSDictionary?)?.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.svForm.contentSize = CGSize(width: screenSize.width,
                                             height: self.vwBox.frame.maxY + keyboardHeight + 20)
        }
    }
    
    @objc private func keyboardWillHide() {
        self.svForm.contentSize = CGSize(width: UIScreen.shared.viewportWidth(),
                                         height: self.vwBox.frame.maxY)
    }
}
