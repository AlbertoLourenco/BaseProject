//
//  RegisterViewController.swift
//

import UIKit

final class RegisterViewController: BaseViewController,
                                    RegisterPresenterDelegate {
    
    @IBOutlet private var textFieldViews: [UIView]!
    
    @IBOutlet private weak var vwBox: UIView!
    @IBOutlet private weak var svForm: UIScrollView!
    
    @IBOutlet private weak var txtName: UITextField!
    @IBOutlet private weak var txtEmail: UITextField!
    @IBOutlet private weak var txtPassword: UITextField!
    @IBOutlet private weak var txtPasswordConfirmation: UITextField!
    @IBOutlet private weak var actLoading: UIActivityIndicatorView!
    @IBOutlet private weak var btnRegister: UIButton!
    
    //-----------------------------------------------------------------------
    //  MARK: - UIViewController -
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
    //  MARK: - Custom methods -
    //-----------------------------------------------------------------------
    
    @IBAction private func register() {
        (presenter as? RegisterPresenter)?.register(name: self.txtName.text,
                                                    email: self.txtEmail.text,
                                                    password: self.txtPassword.text,
                                                    passwordConfirmation: self.txtPasswordConfirmation.text)
    }
    
    private func configUI() {
        
        self.title = Constants.Title.Register
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.actLoading.alpha = 0
        
        Util.tintPlaceholder(field: self.txtName, color: .lightGray)
        Util.tintPlaceholder(field: self.txtEmail, color: .lightGray)
        Util.tintPlaceholder(field: self.txtPassword, color: .lightGray)
        Util.tintPlaceholder(field: self.txtPasswordConfirmation, color: .lightGray)
        
        self.textFieldViews.forEach { view in
            view.layer.cornerRadius = 10
            view.layer.borderWidth = 1
            view.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    
    private func loadUI() {}
    
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
        self.txtName.resignFirstResponder()
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        self.txtPasswordConfirmation.resignFirstResponder()
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
