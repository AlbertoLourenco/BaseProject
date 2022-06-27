//
//  Extensions.swift
//

import UIKit

//-----------------------------------------------------------------------
//  MARK: - UIApplication -
//-----------------------------------------------------------------------

extension UIApplication {
    
    static var topSafeAreaHeight: CGFloat {
        get {
            guard let window = UIApplication.shared.windows.first else {
                return 0
            }
            return window.safeAreaInsets.top
        }
    }
    
    static var bottomSafeAreaHeight: CGFloat {
        get {
            guard let window = UIApplication.shared.windows.first else {
                return 0
            }
            return window.safeAreaInsets.bottom
        }
    }
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"),
            self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        }else{
            return false
        }
    }
}

//-----------------------------------------------------------------------
//  MARK: - UIScrollview -
//-----------------------------------------------------------------------

extension UIScrollView {
    
    func scrollToTop(animated: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.setContentOffset(CGPoint(x: 0, y: UIApplication.topSafeAreaHeight), animated: animated)
        }
    }
    
    func scrollToBottom(animated: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height), animated: animated)
        }
    }
}

//-----------------------------------------------------------------------
//  MARK: - UIColor -
//-----------------------------------------------------------------------

extension UIColor {
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: abs(percentage))
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage))
    }
    
    private func adjust(by percentage: CGFloat = 30.0) -> UIColor {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }
        return .white
    }
    
    static func from(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .newlines).uppercased()
        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
        if ((cString.count) != 6) { return UIColor.gray }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: CGFloat(1.0))
    }
    
     func image() -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

//-----------------------------------------------------------------------
//  MARK: - UIButton -
//-----------------------------------------------------------------------

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(color.image(), for: state)
    }
}

//-----------------------------------------------------------------------
//  MARK: - UIImage -
//-----------------------------------------------------------------------

extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}

//-----------------------------------------------------------------------
//  MARK: - Int -
//-----------------------------------------------------------------------

extension Int {
    func format() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = "."
        formater.numberStyle = .decimal
        return formater.string(from: NSNumber(value: self)) ?? ""
    }
}

//-----------------------------------------------------------------------
//	MARK: - Dictionary -
//-----------------------------------------------------------------------

extension Dictionary {
	func buildQueryString() -> String {
		var urlVars:[String] = []
		for (key, value) in self {
			if value is Array<Any> {
				for v in value as! Array<Any> {
					if let encodedValue = "\(v)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
						urlVars.append((key as! String) + "[]=" + encodedValue)
					}
				}
			}else{
                if let val = value as? String {
                    if let encodedValue = val.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                        urlVars.append((key as! String) + "=" + encodedValue)
                    }
                }else{
                    urlVars.append((key as! String) + "=\(value)")
                }
			}
		}
		return urlVars.isEmpty ? "" : "?" + urlVars.joined(separator: "&")
	}
}

//-----------------------------------------------------------------------
//  MARK: - UIView -
//-----------------------------------------------------------------------

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable
    var masksToBounds: Bool {
        get { return layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }
    
    @IBInspectable
    var shadowColor: UIColor {
        get { return UIColor(cgColor: layer.shadowColor ?? UIColor.clear.cgColor) }
        set { layer.shadowColor = newValue.cgColor }
    }
    
    @IBInspectable
    var shadowOpacity: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    func dashed() {
        let dashed = CAShapeLayer()
        dashed.strokeColor = UIColor.white.cgColor
        dashed.lineWidth = 4
        dashed.lineDashPattern = [3,5]
        dashed.frame = self.bounds
        dashed.fillColor = nil
        dashed.path = UIBezierPath(rect: bounds).cgPath
        layer.addSublayer(dashed)
    }
}

//-----------------------------------------------------------------------
//  MARK: - Date -
//-----------------------------------------------------------------------

extension Date {
    
    func isLeapYear() -> Bool {
        let year = Calendar.current.component(.year, from: self)
        return ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
    }
    
    func getDayInYear() -> Int {
        return Calendar.current.ordinality(of: .day, in: .year, for: self)!
    }
    
    func getDay() -> Int {
        return Calendar.current.ordinality(of: .day, in: .month, for: self)!
    }
    
    func getMonth() -> Int {
        return Calendar.current.ordinality(of: .month, in: .year, for: self)!
    }
    
    func getYear() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func today(withTime: Bool = true) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = withTime ? "yyyy-MM-dd HH:mm:ss" : "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    func formatDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

//-----------------------------------------------------------------------
//  MARK: - Double -
//-----------------------------------------------------------------------

extension Double {
    
    func format() -> String {
        let value = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.groupingSeparator = "."
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        formatter.decimalSeparator = ","
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: value)!
    }
}

//-----------------------------------------------------------------------
//  MARK: - Float -
//-----------------------------------------------------------------------

extension Float {
    
    func format() -> String {
        let value = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.groupingSeparator = "."
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        formatter.decimalSeparator = ","
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter.string(from: value)!
    }
    
    func currency() -> String {
        let value = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "BRL"
        var strValue: String = formatter.string(from: value)?.replacingOccurrences(of: "$", with: "$ ") ?? ""
        strValue = strValue.replacingOccurrences(of: ".", with: ",")
        return strValue
    }
    
    func round(decimalPlace:Int) -> Float{
        let format = String(format: "%%.%if", decimalPlace)
        let string = String(format: format, self)
        return Float(string) ?? 0
    }
}

//-----------------------------------------------------------------------
//  MARK: - URLResponse -
//-----------------------------------------------------------------------

extension URLResponse {
    
    func getStatusCode() -> Int {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return 0
    }
}

//-----------------------------------------------------------------------
//	MARK: - String -
//-----------------------------------------------------------------------

extension String {
	
    func index(of char: Character, text: String) -> Int {
        return self.firstIndex(of: char)?.utf16Offset(in: text) ?? 0
    }
    
    func substringWithRange(aRange : CFRange) -> String {
        let nsrange = NSMakeRange(aRange.location, aRange.length)
        let substring = (self as NSString).substring(with: nsrange)
        return substring
    }
    
    func underline() -> NSAttributedString {
        let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func html() -> NSAttributedString? {
        if let textData = self.data(using: .utf16) {
            return try? NSAttributedString(data: textData,
                                           options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html],
                                           documentAttributes: nil)
        }
        return nil
    }
    
    func count(of stringToFind: String) -> Int {
        var stringToSearch = self
        var count = 0
        while let foundRange = stringToSearch.range(of: stringToFind, options: .diacriticInsensitive) {
            stringToSearch = stringToSearch.replacingCharacters(in: foundRange, with: "")
            count += 1
        }
        return count
    }
    
    func stripTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func digits() -> String {
        return self.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
    }
    
    func letters() -> String {
        return self.replacingOccurrences(of: "[^a-zA-Z]+", with: "", options: .regularExpression)
    }
    
    var isValidCPF: Bool {
        
        let numbers = compactMap({Int(String($0))})
        
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        
        let sum1 = 11 - ( numbers[0] * 10 +
            numbers[1] * 9 +
            numbers[2] * 8 +
            numbers[3] * 7 +
            numbers[4] * 6 +
            numbers[5] * 5 +
            numbers[6] * 4 +
            numbers[7] * 3 +
            numbers[8] * 2 ) % 11
        
        let dv1 = sum1 > 9 ? 0 : sum1
        
        let sum2 = 11 - ( numbers[0] * 11 +
            numbers[1] * 10 +
            numbers[2] * 9 +
            numbers[3] * 8 +
            numbers[4] * 7 +
            numbers[5] * 6 +
            numbers[6] * 5 +
            numbers[7] * 4 +
            numbers[8] * 3 +
            numbers[9] * 2 ) % 11
        
        let dv2 = sum2 > 9 ? 0 : sum2
        
        return dv1 == numbers[9] && dv2 == numbers[10]
    }
    
    var isValidCNPJ: Bool {
        
        let numbers = compactMap({Int(String($0))})
        
        guard numbers.count == 14 && Set(numbers).count != 1 else { return false }
        
        let sum1 = 11 - ( numbers[11] * 2 +
            numbers[10] * 3 +
            numbers[9] * 4 +
            numbers[8] * 5 +
            numbers[7] * 6 +
            numbers[6] * 7 +
            numbers[5] * 8 +
            numbers[4] * 9 +
            numbers[3] * 2 +
            numbers[2] * 3 +
            numbers[1] * 4 +
            numbers[0] * 5 ) % 11
        
        let dv1 = sum1 > 9 ? 0 : sum1
        
        let sum2 = 11 - ( numbers[12] * 2 +
            numbers[11] * 3 +
            numbers[10] * 4 +
            numbers[9] * 5 +
            numbers[8] * 6 +
            numbers[7] * 7 +
            numbers[6] * 8 +
            numbers[5] * 9 +
            numbers[4] * 2 +
            numbers[3] * 3 +
            numbers[2] * 4 +
            numbers[1] * 5 +
            numbers[0] * 6 ) % 11
        
        let dv2 = sum2 > 9 ? 0 : sum2
        
        return dv1 == numbers[12] && dv2 == numbers[13]
    }
    
    var isValidEmail: Bool {
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}",
                                             options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil && !self.contains(" ")
    }
    
    func dateFromString(with format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

//-----------------------------------------------------------------------
//  MARK: - UIScreen -
//-----------------------------------------------------------------------

extension UIScreen {
    
    static let shared = UIScreen()
    
    func viewportWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }

    func viewportHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
        
    func viewportBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}

//-----------------------------------------------------------------------
//	MARK: - UIDevice -
//-----------------------------------------------------------------------

extension UIDevice {
	
    static let shared = UIDevice()
    
	func screenModel() -> ScreenModel {
		
		let w: Double = Double(UIScreen.main.bounds.width)
		let h: Double = Double(UIScreen.main.bounds.height)
		let screenHeight: Double = max(w, h)
		
		switch screenHeight {
			
			case 480:
				return .iPhone_4
			
			case 568:
				return .iPhone_5
			
			case 667:
				return UIScreen.main.scale == 3.0 ? .iPhone_Plus : .iPhone_8
			
			case 736:
				return .iPhone_Plus
			
            case 812, 844, 896:
				return .iPhone_X
			
			default:
				return .iPad
		}
	}
    
    var iOSVersion: String {
        return UIDevice.current.systemVersion
    }
    
    var imei: String {
        guard let value = UIDevice.current.identifierForVendor?.uuidString else {
            return ""
        }
        return value
    }
    
    var deviceName: String {
        return UIDevice.current.name
    }
    
    var deviceToken: String {
        guard let value = UserDefaults.standard.object(forKey: "deviceToken") as? String else {
            return ""
        }
        return value
    }
}
