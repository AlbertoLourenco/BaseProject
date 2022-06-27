//
//  IAPManager.swift
//

import StoreKit

enum IAPManagerProductIdentifier: String {
    case free = ""
    case lifeTime = "APP_PRODUCT"
}

protocol IAPManagerDelegate {
    func purchaseRestoreProcessing(loading: Bool)
    func purchaseProcessing(loading: Bool)
    func purchaseCanceled()
    func purchaseFailed(error: String)
    func purchaseFinished()
    func purchaseRestored()
    func purchaseRestoredFailed(error: String)
}

class IAPManager: NSObject, SKProductsRequestDelegate, SKRequestDelegate{
    
    static let shared = IAPManager()
    
    var delegate: IAPManagerDelegate?
    
    var products: Array<SKProduct> = []
    var totalRestoredPurchases: Int = 0
    
    var cantMakePayments: String = "You cannot make payments. Try again later."
    
    private override init() {
        super.init()
        
        //------------------------------
        //  Get products
        //------------------------------
        
        let request = SKProductsRequest(productIdentifiers: Set([IAPManagerProductIdentifier.lifeTime.rawValue]))
        request.delegate = self
        request.start()
    }
    
    func startObserving() {
        SKPaymentQueue.default().add(self)
    }
    
    func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }
    
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func getProduct(identifier: IAPManagerProductIdentifier) -> SKProduct? {
        return products.filter{ $0.productIdentifier == identifier.rawValue }.first
    }
    
    func buy(product: SKProduct) {
        
        if self.canMakePayments() {
         
            self.delegate?.purchaseProcessing(loading: true)
            
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }else{
            self.delegate?.purchaseFailed(error: cantMakePayments)
        }
    }
    
    func restorePurchases() {
        
        if self.canMakePayments() {
        
            totalRestoredPurchases = 0
            self.delegate?.purchaseRestoreProcessing(loading: true)
            SKPaymentQueue.default().restoreCompletedTransactions()
        }else{
            self.delegate?.purchaseRestoredFailed(error: cantMakePayments)
        }
    }
    
    func getPurchaseReceipt() -> String {
        
        var receipt = ""
        
        do {
            let data: NSData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!,
                                          options: NSData.ReadingOptions.alwaysMapped)
            receipt = data.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
        }catch{
            print("IAPManager - \(error.localizedDescription)")
        }
        
        print("token: \(receipt)")
        return receipt
    }
    
    //-------------------------------------------------
    //  SKProductsRequest Delegate
    //-------------------------------------------------
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("IAPManager - \(error.localizedDescription)")
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    
    //----------------------------------------
    //  Purchasing
    //----------------------------------------
    
    func paymentQueue(_ queue: SKPaymentQueue,
                      updatedTransactions transactions: [SKPaymentTransaction]) {
        
        transactions.forEach { (transaction) in
            
            switch transaction.transactionState {
                
                case .purchased:
                    self.delegate?.purchaseProcessing(loading: false)
                    self.delegate?.purchaseFinished()
                    SKPaymentQueue.default().finishTransaction(transaction)
                break
                
                case .restored:
                    totalRestoredPurchases += 1
                    SKPaymentQueue.default().finishTransaction(transaction)
                break
                
                case .failed:
                    self.delegate?.purchaseProcessing(loading: false)
                    if let error = transaction.error as? SKError {
                        if error.code == .paymentCancelled {
                            self.delegate?.purchaseCanceled()
                        } else {
                            self.delegate?.purchaseFailed(error: error.localizedDescription)
                        }
                    }
                    SKPaymentQueue.default().finishTransaction(transaction)
                break
                
                case .deferred, .purchasing:
                    self.delegate?.purchaseProcessing(loading: true)
                break
            @unknown default:
                break
            }
        }
    }
    
    //----------------------------------------
    //  Restore
    //----------------------------------------
    
    func paymentQueue(_ queue: SKPaymentQueue,
                      restoreCompletedTransactionsFailedWithError error: Error) {
        self.delegate?.purchaseRestoreProcessing(loading: false)
        self.delegate?.purchaseRestoredFailed(error: error.localizedDescription)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        self.delegate?.purchaseRestoreProcessing(loading: false)
        self.delegate?.purchaseRestored()
    }
}
