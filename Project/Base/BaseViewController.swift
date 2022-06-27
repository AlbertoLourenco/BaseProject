//
//  BaseViewController.swift
//

import UIKit

class BaseViewController: UIViewController {
	
    var presenter: BasePresenter!
    
	//-----------------------------------------------------------------------
	//	MARK: - UIViewController -
	//-----------------------------------------------------------------------
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        self.configNavbar()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeChanged),
                                               name: Constants.Notification.ThemeUpdated,
                                               object: nil)
        
        if UIDevice().screenModel() == .iPad {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(rotated),
                                                   name: UIDevice.orientationDidChangeNotification,
                                                   object: nil)
        }
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
	}
    
    //-----------------------------------------------------------------------
    //  MARK: - Custom methods -
    //-----------------------------------------------------------------------
    
    @objc func rotated() {} // rotated screen
    
    @objc func themeChanged() {}
    
    private func configNavbar() {
        
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = Color.Purple_Green
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc private func backNavigation() {
        presenter.closeView()
    }
}
