//
//  ForgotPasswordViewController.swift
//

import UIKit

final class ForgotPasswordViewController: BaseViewController,
                                          ForgotPasswordPresenterDelegate {
    
    @IBOutlet private weak var vwBox: UIView!
    @IBOutlet private weak var svForm: UIScrollView!
    
    @IBOutlet private weak var vwLogin: UIView!
    @IBOutlet private weak var btnRecover: UIButton!
    @IBOutlet private weak var txtLogin: UITextField!
    @IBOutlet private weak var actLoading: UIActivityIndicatorView!
    
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
    //  MARK: - Presenter Delegate -
    //-----------------------------------------------------------------------
    
    func loading(_ loading: Bool) {
        if loading {
            Util.showHUD()
        }else{
            Util.hideHUD()
        }
    }
    
    //-----------------------------------------------------------------------
    //	MARK: - Custom methods -
    //-----------------------------------------------------------------------
    
    func configUI() {
        
        self.title = Constants.Title.ForgotPassword
        
        self.configKeyboard()
        
        self.vwLogin.layer.borderWidth = 1
        self.vwLogin.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        self.vwLogin.layer.cornerRadius = 10
    }
    
    @IBAction func recoverPassword() {
        (presenter as? ForgotPasswordPresenter)?.recoverPassword(email: self.txtLogin.text)
    }
    
    //-----------------------------------------------------------------------
    //  MARK: - Keyboard -
    //-----------------------------------------------------------------------
    
    func configKeyboard() {
        
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
    
    @objc func hideKeyboard() {
        self.txtLogin.resignFirstResponder()
    }
    
    @objc func keyboardDidAppear(notification: Notification) {
        let screenSize = UIScreen.main.bounds.size
        if let keyboardFrame = (notification.userInfo as NSDictionary?)?.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.svForm.contentSize = CGSize(width: screenSize.width,
                                             height: self.vwBox.frame.maxY + keyboardHeight + 20)
        }
    }
    
    @objc func keyboardWillHide() {
        self.svForm.contentSize = CGSize(width: UIScreen.shared.viewportWidth(),
                                         height: self.vwBox.frame.maxY)
    }
}
