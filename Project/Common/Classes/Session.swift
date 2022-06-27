//
//  Session.swift
//

import UIKit

class Session: NSObject {
	
	static var auth: Auth?
	
    static func resetOffline() {
        
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "User_name")
        defaults.removeObject(forKey: "User_email")
        defaults.removeObject(forKey: "User_phone")
        defaults.removeObject(forKey: "User_avatar")
        
        defaults.synchronize()
    }
    
    static func set(auth: Auth) {
		   
		Session.auth = auth
		
        let defaults = UserDefaults.standard
        
        defaults.setValue(auth.objectId, forKey: "Auth_objectId")
        defaults.setValue(auth.name, forKey: "Auth_name")
        defaults.setValue(auth.email, forKey: "Auth_email")
        defaults.setValue(auth.token, forKey: "Auth_token")
        defaults.setValue(auth.paid, forKey: "Auth_paid")
        defaults.setValue(auth.phone, forKey: "Auth_phone")
        defaults.setValue(auth.avatar, forKey: "Auth_avatar")
        
        defaults.synchronize()
	}
    
	static func get() -> Auth? {
		
		let defaults = UserDefaults.standard
		
		if let token = defaults.object(forKey: "Auth_token") as? String {
			
            let userId = defaults.object(forKey: "Auth_objectId") as? Int
            let name = defaults.object(forKey: "Auth_name") as? String
            let email = defaults.object(forKey: "Auth_email") as? String
            let avatar = defaults.object(forKey: "Auth_avatar") as? String
            let paid = defaults.object(forKey: "Auth_paid") as? Bool
            let phone = defaults.object(forKey: "Auth_phone") as? String
        
            Session.auth = Auth(objectId: userId ?? 0,
                                name: name ?? "",
                                email: email ?? "",
                                phone: phone ?? "",
                                paid: paid ?? false,
                                avatar: avatar ?? "",
                                token: token)
			
			return Session.auth
		}
		
		return nil
	}
	
    static func logout() {
        
        Session.auth = nil
        
        Cache.clear()
        
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "User_name")
        defaults.removeObject(forKey: "User_email")
        defaults.removeObject(forKey: "User_phone")
        defaults.removeObject(forKey: "User_avatar")
        
        defaults.removeObject(forKey: "Auth_token")
        defaults.removeObject(forKey: "Auth_objectId")
        defaults.removeObject(forKey: "Auth_name")
        defaults.removeObject(forKey: "Auth_email")
        defaults.removeObject(forKey: "Auth_paid")
        defaults.removeObject(forKey: "Auth_avatar")
        
        defaults.synchronize()
    }
}
