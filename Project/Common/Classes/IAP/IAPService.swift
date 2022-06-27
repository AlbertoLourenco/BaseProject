//
//  IAPService.swift
//

import StoreKit

enum IAPProduct: String {
    case signatureMonthly = "month"
    case signatureSemiannually = "semiannual"
    case signatureAnnually = "annual"
}

//-----------------------------------------------------------------------
//  MARK: - Presenter Delegate
//-----------------------------------------------------------------------

protocol IAPServiceDelegate {
    func onProcessBuy(success: Bool, base64encodedReceipt: String, message: String?)
}

//-----------------------------------------------------------------------
//  MARK: - In App Purchase Service
//-----------------------------------------------------------------------

class IAPService: NSObject {

    let paymentQueue = SKPaymentQueue.default()
    var products = [SKProduct]()
    
    var delegate: IAPServiceDelegate?
    
    private override init() {}
    
    init (delegate: IAPServiceDelegate?) {
        self.delegate = delegate
        
        super.init()
    }
    
    func getProducts() {
        
        let request = SKProductsRequest(productIdentifiers: [IAPProduct.signatureMonthly.rawValue])
        request.delegate = self
        request.start()
        
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProduct) {
        
        guard let productToPurchase = products.filter({$0.productIdentifier == product.rawValue}).first else { return }
        
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restore() {
        paymentQueue.restoreCompletedTransactions()
    }
}

extension IAPService: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
            self.products = response.products
    }
}

extension IAPService: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
                case .purchasing: break
                case .purchased, .restored, .failed:
                    handlePayment(transaction: transaction)
                break
                default: break
            }
            
            if let error = transaction.error {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func handlePayment(transaction: SKPaymentTransaction) {
        
        do {
            let receiptData: NSData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
            let base64encodedReceipt = receiptData.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
            
            self.delegate?.onProcessBuy(success: true, base64encodedReceipt: base64encodedReceipt, message: nil)
            
            paymentQueue.finishTransaction(transaction)
        }catch{
            self.delegate?.onProcessBuy(success: false, base64encodedReceipt: "", message: transaction.error?.localizedDescription)
        }
    }
}

extension SKPaymentTransactionState {
    
    func status() -> String {
        
        switch self {
            case .deferred: return "deferred"
            case .failed: return "failed"
            case .purchased: return "purchased"
            case .purchasing: return "purchasing"
            case .restored: return "restored"
        @unknown default:
            fatalError()
        }
    }
}
