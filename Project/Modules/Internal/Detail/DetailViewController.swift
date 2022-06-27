//
//  DetailViewController.swift
//

import UIKit

final class DetailViewController: BaseViewController,
                                  DetailPresenterDelegate {
    
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
        
        self.title = Constants.Title.HomeDetail
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func loadUI() {
        
    }
}
