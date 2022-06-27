//
//  HomeViewController.swift
//

import UIKit

final class HomeViewController: BaseViewController,
                                HomePresenterDelegate {
    
    @IBOutlet private weak var scTheme: UISegmentedControl!
    
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
    
    func loadedData() {
        // TO DO
    }
    
    //-----------------------------------------------------------------------
    //  MARK: - Custom methods -
    //-----------------------------------------------------------------------
    
    private func configUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.scTheme.selectedSegmentIndex = Preferences.theme == .dark ? 1 : 0
    }
    
    private func loadUI() {
        
    }
    
    @IBAction private func logout() {
        (presenter as? HomePresenter)?.logout()
    }
    
    @IBAction private func showDetail() {
        presenter.router.showDetail()
    }
    
    @IBAction private func changeTheme(sender: UISegmentedControl) {
        Preferences.toggleTheme()
    }
}
