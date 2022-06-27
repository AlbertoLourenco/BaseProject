//
//  Preferences.swift
//

import UIKit

class Preferences: NSObject {
	
    static func clear() {
        Preferences.toggleTheme(reset: true)
    }
    
    //------------------------------------------------------------
    //  UI and Unit Tests flags
    //------------------------------------------------------------
    
    //  Is running tests
    
    private static var preferenceIsRunningTests = false
    
    public static var isRunningTests: Bool {
        get { return preferenceIsRunningTests }
        set (newValue) { preferenceIsRunningTests = newValue }
    }
    
    //  Is running fail tests
    
    public static var isRunningTestsFail: Bool {
        get { return UserDefaults.standard.bool(forKey: "RunningTests_Fail") }
        set (newValue) { UserDefaults.standard.set(newValue, forKey: "RunningTests_Fail") }
    }
    
    //------------------------------------------------------------
    //  User theme preference
    //------------------------------------------------------------
    
    static var theme: UIUserInterfaceStyle {
        get {
            return UserDefaults.standard.bool(forKey: "Defaults_Theme") ? .dark : .light
        }
    }
    
    static func toggleTheme(reset: Bool = false) {
        
        var theme: UIUserInterfaceStyle!
        
        if reset {
            theme = .light
        }else{
            theme = Preferences.theme == .dark ? .light : .dark
        }
        
        UserDefaults.standard.set((theme == .dark), forKey: "Defaults_Theme")
        
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = Preferences.theme
        
        NotificationCenter.default.post(name: Constants.Notification.ThemeUpdated, object: nil)
    }
}
