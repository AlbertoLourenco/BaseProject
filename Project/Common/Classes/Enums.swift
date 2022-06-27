//
//  Enums.swift
//

import Foundation

//------------------------------------------------------------
//	Module: all UI that needs update frame
//------------------------------------------------------------

enum ScreenModel {
    
    case unknown
    case iPhone_4       // iPhone 4 and 4S
    case iPhone_5       // iPod Touch, iPhone 5, 5C, 5S and SE
    case iPhone_8       // iPhone 6, 6S, 7 and 8
    case iPhone_Plus    // iPhone 6 Plus, 7 Plus and 8 Plus
    case iPhone_X
    case iPad
}

//-----------------------------------------------------------------------
//  Class: TabCell
//-----------------------------------------------------------------------

enum TabItemType {
    case soon
    case free
    case premium
}

//-----------------------------------------------------------------------
//	Struct: BaseRouter
//-----------------------------------------------------------------------

enum PresentationStyle {
	case modal
	case push
}

//-----------------------------------------------------------------------
//	Struct: HomeBaseViewController
//-----------------------------------------------------------------------

enum ContainerType {
	case home
    case other
}

//------------------------------------------------------------
//	Struct: BaseManager
//------------------------------------------------------------

enum ResponseError: Error {
	case none
	case unknown
	case invalidCredentials
}

enum RequestType {
    case get
    case post
    case put
}

//------------------------------------------------------------
//	Util - Messages
//------------------------------------------------------------

public enum MessageType {
    case info
	case success
	case warning
	case error
}

//-----------------------------------------------------------------------
//  Struct: Mock
//-----------------------------------------------------------------------

enum MockType: String {
    case error
    case none
    case login
}
