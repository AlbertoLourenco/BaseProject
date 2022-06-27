//
//  Constants.swift
//

import UIKit

final class Constants {
    
    struct AppID {
        static let OneSignal = "0000000-0000000-0000000-0000000"
    }
    
    struct Layout {
        static let PopUpSize = CGSize(width: UIScreen.shared.viewportWidth() - 20, height: 470)
    }
    
    struct API {
        
#if PROD
        static let BaseURL = "https://URL_PROD/"
#else
        static let BaseURL = "https://URL_HOMOL/"
#endif
        
        static let CEPURL = "https://viacep.com.br/ws/"
        
        struct Endpoint {
            static let Login = "login"
            static let Register = "register"
            static let ForgotPassword = "forgotPassword"
        }
    }
    
    struct Notification {
        static let ThemeUpdated = NSNotification.Name(rawValue: "Notification_ThemeUpdated")
        static let ShowModule = NSNotification.Name(rawValue: "Notification_ShowModule")
        static let ReloadData = NSNotification.Name(rawValue: "Notification_ReloadData")
        static let BecomeActive = NSNotification.Name(rawValue: "Notification_BecomeActive")
        static let EnterBackground = NSNotification.Name(rawValue: "Notification_EnterBackground")
        static let EnterForeground = NSNotification.Name(rawValue: "Notification_EnterForeground")
    }
    
    struct Strings {
        
        struct Tabbar {
            static let Item_01 = "Home"
            static let Item_02 = "Blank"
        }
        
        static let NO = "No"
        static let YES = "Yes"
        static let Version = "Version"
        static let Cancel = "Cancel"
        static let Library = "Library"
        static let Camera = "Camera"
        static let SeeAll = "See all"
        static let Delete = "Delete"
        static let Edit = "Edit"
        static let Exit = "Exit"
        static let SelectOption = "Select an option"
        static let OK = "Ok"
        
        static let Soon = "Soon"
        static let Paid = "Paid"
        
        static let Copy = "Copy"
        static let Share = "Share"
    }
    
    struct Title {
        static let Register = "Register"
        static let HomeDetail = "Detail"
        static let ForgotPassword = "Forgot Password"
    }
    
    struct Form {
        
        struct Debug {
            static let login = "email@company.com.br"
            static let password = "Y0uRP4S5w0rd"
        }
    }
    
    struct Messages {
        static let EmailSentSuccess = "Email sent with success."
        static let RegisteredSuccess = "User registered with success."
        static let InvalidEmail = "Type a valid email address."
        static let UnknowError = "Unkown error."
        static let FillRequiredFields = "Fill all required fields."
        static let PasswordsNotMatch = "Passwords does not match."
        static let YoureOffline = "You are off-line."
        static let YoureOnline = "You are on-line."
    }
}
