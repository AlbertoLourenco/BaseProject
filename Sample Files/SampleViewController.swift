//
//  <#moduleName#>ViewController.swift
//

import UIKit

final class <#moduleName#>ViewController: BaseViewController, <#moduleName#>PresenterDelegate {
    
    var presenter: <#moduleName#>Presenter!
    
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
    
    override func configDarkMode() {
        super.configDarkMode()
        
        // TO-DO
    }
    
    //-----------------------------------------------------------------------
    //  MARK: - Presenter Delegate -
    //-----------------------------------------------------------------------
    
    func loadedData() {
        // TO DO
    }
    
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
    
    func configUI() {
        
    }
    
    func loadUI() {
        
    }
}
