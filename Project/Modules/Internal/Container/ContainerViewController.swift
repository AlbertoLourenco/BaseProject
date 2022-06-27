//
//  ContainerViewController.swift
//

import UIKit

final class ContainerViewController: BaseViewController,
                                     UICollectionViewDelegate,
                                     UICollectionViewDataSource,
                                     UICollectionViewDelegateFlowLayout {
	
    private var selectedTab = -1
    private var wasOffline = false
	private var transitionInProgress = false
	private var containerController = ContainerType.home
	private var currentViewController: UIViewController?
    
    private var tabItems: Array<TabItem> = []
    private var tabItemWidth: CGFloat = 90
    
    @IBOutlet private var vwTabbar: UIView!
    @IBOutlet private var vwContainer: UIView!
    
    @IBOutlet private var vwWarning: UIView!
    @IBOutlet private var lblWarningMessage: UILabel!
    
    @IBOutlet private var cvTab: UICollectionView!
    
	@IBOutlet private var constraintHeightTabbar: NSLayoutConstraint!
    @IBOutlet private var constraintHeightWarning: NSLayoutConstraint!
    
	//-----------------------------------------------------------------------
	//	MARK: - UIViewController -
	//-----------------------------------------------------------------------
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        self.configUI()
	}
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        
        self.constraintHeightTabbar.constant = (UIDevice().screenModel() == .iPhone_X) ? 90 : 60
        self.view.layoutIfNeeded()
        
        self.hideWarning(animated: false)
        self.loadTabs()
	}
    
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if currentViewController == nil {
			self.changeView(index: 0)
		}
        
        self.setupReachability()
        self.cvTab.reloadData()
	}
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Reachability.shared.stopNotifier()
    }
    
    //-----------------------------------------------------------------------
    //  MARK: - BaseViewController -
    //-----------------------------------------------------------------------
    
    override func rotated() {
        if UIDevice.current.orientation.isLandscape ||
            UIDevice.current.orientation.isPortrait {
            self.cvTab.reloadData()
        }
    }
    
    override func themeChanged() {
        // TO-DO
    }
    
    //-----------------------------------------------------------------------
    //  MARK: - UICollectionView Delegate / Datasource -
    //-----------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return tabItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = tabItems[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath) as! TabCell
        cell.loadUI(object: item, selected: containerController == item.container)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        self.changeView(index: indexPath.item)
    }
    
    //-----------------------------
    //  Flow layout
    //-----------------------------
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: tabItemWidth, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
	//-----------------------------------------------------------------------
	//	MARK: - Custom methods -
	//-----------------------------------------------------------------------
    
    private func configUI() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showModule(notification:)),
                                               name: Constants.Notification.ShowModule,
                                               object: nil)
        
        if UIDevice().screenModel() == .iPad {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(rotated),
                                                   name: UIDevice.orientationDidChangeNotification,
                                                   object: nil)
        }
    }
    
    private func setupReachability() {
        
        if let _ = Session.get() {

            Reachability.shared.whenReachable = { _ in
                if self.wasOffline {
                    self.showWarning(message: Constants.Messages.YoureOnline,
                                     textColor: Color.white,
                                     backgroundColor: Color.Green)
                }
            }
            
            Reachability.shared.whenUnreachable = { _ in
                self.wasOffline = true
                self.showWarning(message: Constants.Messages.YoureOffline,
                                 textColor: Color.white,
                                 backgroundColor: Color.Red)
            }
            
            do {
                try Reachability.shared.startNotifier()
            }catch{
                print("Unable to start notifier")
            }
        }
        
    }
    
    @objc private func showModule(notification: Notification) {
        
        if let number = notification.object as? NSNumber {
            
            if UIApplication.topViewController() is ContainerViewController {
                
                self.cvTab.scrollToItem(at:IndexPath(item: number.intValue, section: 0), at: .right, animated: false)
                
                self.changeView(index: number.intValue)
            }
        }
    }
    
    @IBAction private func changeView(index: Int) {
        
        self.cvTab.reloadData()
        
        let tabItem = tabItems[index]
        
        if transitionInProgress ||
            index == selectedTab ||
            tabItem.status == .soon {
            return
        }
        
        selectedTab = index
        containerController = tabItem.container
        
        var router: BaseRouter!
        
        switch tabItem.container {
            case .home:
                router = HomeRouter()
                break
            case .other:
                router = BlankRouter()
                break
        }
        
        var viewController: BaseViewController!
        if let controller = router.viewController as? BaseViewController {
            viewController = controller
        }
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.view.frame = self.vwContainer.frame
        
        if self.currentViewController != nil {
            self.currentViewController?.willMove(toParent: nil)
            self.currentViewController?.view.removeFromSuperview()
            self.currentViewController?.removeFromParent()
        }
        
        self.addChild(navController)
        
        self.currentViewController?.removeFromParent()
        
        self.vwContainer?.addSubview(navController.view)
        navController.didMove(toParent: self)
        
        self.transitionInProgress = false
        self.currentViewController = navController
    }
    
    private func loadTabs() {
        
        tabItems = [TabItem(title: Constants.Strings.Tabbar.Item_01,
                            image: Image.TabbarEmpty_01,
                            imageSelected: Image.TabbarFilled_01,
                            status: .free,
                            container: .home),
                    TabItem(title: Constants.Strings.Tabbar.Item_02,
                            image: Image.TabbarEmpty_01,
                            imageSelected: Image.TabbarFilled_01,
                            status: .premium,
                            container: .other)]
        
        self.configTabWidth()
        
        self.cvTab.reloadData()
    }
    
    private func configTabWidth() {
        let divider: CGFloat = (UIDevice().screenModel() == .iPad) ? 8.2 : 4.8
        tabItemWidth = UIScreen.shared.viewportWidth() / divider
        if tabItemWidth * CGFloat(tabItems.count) < UIScreen.shared.viewportWidth() {
            tabItemWidth = UIScreen.shared.viewportWidth() / CGFloat(tabItems.count)
        }
    }
    
    private func showWarning(message: String,
                             textColor: UIColor,
                             backgroundColor: UIColor) {
        
        DispatchQueue.main.async {
            
            self.vwWarning.backgroundColor = backgroundColor
            self.lblWarningMessage.textColor = textColor
            self.lblWarningMessage.text = message
            
            self.constraintHeightWarning.constant = 20
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.hideWarning(animated: true)
            }
        }
    }
    
    private func hideWarning(animated: Bool) {
        
        self.constraintHeightWarning.constant = 0
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }else{
            self.view.layoutIfNeeded()
        }
    }
}
