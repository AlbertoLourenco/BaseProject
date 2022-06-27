//
//  Util.swift
//

import UIKit
import Lottie
import NotificationBannerSwift

final class Util {
    
    //------------------------------------------------------------
    //  MARK: - Helpers -
    //------------------------------------------------------------
    
    static var isOffline: Bool {
        get { return Reachability.shared.connection == .unavailable }
    }
    
    static func getAppVersion() -> String {
        if let info = Bundle.main.infoDictionary,
            let version = info["CFBundleShortVersionString"] as? String,
            let build = info["CFBundleVersion"] as? String {
            return "\(Constants.Strings.Version): \(version) (\(build))"
        }
        return ""
    }
    
    static func tintPlaceholder(field: UITextField, color: UIColor = .white) {
        if let placeholder = field.placeholder {
            field.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.6)])
        }
    }
    
    //------------------------------------------------------------
    //  MARK: - Messages -
    //------------------------------------------------------------
    
    static func showMessage(title: String? = nil,
                            message: String? = nil,
                            type: MessageType) {
        var messageType: BannerStyle = .warning
        switch type {
            case .success:
                messageType = .success
            case .info:
                messageType = .info
            case .warning:
                messageType = .warning
            case .error:
                messageType = .danger
        }
        let banner = NotificationBanner(title: title,
                                        subtitle: message,
                                        style: messageType)
        banner.show()
    }
    
    //------------------------------------------------------------
    //  MARK: - HUD -
    //------------------------------------------------------------
    
    static private var hudMask = UIView(frame: UIScreen.main.bounds)
    
    static func showHUD() {
        
        if hudMask.subviews.count > 0 { return }
        
        hudMask.alpha = 0
        hudMask.frame = UIScreen.main.bounds
        hudMask.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)
        
        let hudSquare: CGFloat = 220
        var hudCenter = hudMask.center
        hudCenter.x -= hudSquare/2
        hudCenter.y -= hudSquare/1.5
        
        let boxView = UIView(frame: CGRect(origin: hudCenter,
                                           size: CGSize(width: hudSquare,
                                                        height: hudSquare)))
        boxView.backgroundColor = .clear
        boxView.alpha = 0
        hudMask.addSubview(boxView)
        
        let animation = AnimationView(name: "loading")
        animation.frame = CGRect(origin: .zero, size: boxView.frame.size)
        animation.loopMode = .loop
        animation.play()
        boxView.addSubview(animation)
        
        let window: UIWindow? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        window?.addSubview(hudMask)
        
        UIView.animate(withDuration: 0.3) { hudMask.alpha = 1 }
        UIView.animate(withDuration: 0.6) { boxView.alpha = 1 }
    }
    
    static func hideHUD() {
        UIView.animate(withDuration: 0.5,
                       animations: { hudMask.alpha = 0 },
                       completion: { (finished) in
                        if finished {
                            hudMask.removeFromSuperview()
                            hudMask = UIView(frame: UIScreen.main.bounds)
                        }
                       })
    }
}
