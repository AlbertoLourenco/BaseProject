//
//  TabCell.swift
//

import UIKit

class TabCell: UICollectionViewCell {
    
    @IBOutlet private weak var imgIcon: UIImageView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblBadge: UILabel!
    
    func loadUI(object: TabItem, selected: Bool = false) {
        
        self.imgIcon.image = object.image
        self.lblTitle.text = object.title
        
        self.imgIcon.tintColor = Color.Gray
        self.lblTitle.textColor = Color.Gray
        
        if selected {
            self.imgIcon.tintColor = Color.Purple_Green
            self.lblTitle.textColor = Color.Purple_Green
            self.imgIcon.image = object.imageSelected
        }
        
        switch object.status {
            
            case .free:
                self.lblBadge.isHidden = true
            
            case .premium:
                if let user = Session.get(), user.paid {
                    self.lblBadge.isHidden = true
                }else{
                    self.lblBadge.isHidden = false
                    self.lblBadge.text = Constants.Strings.Paid.uppercased()
                    self.lblBadge.backgroundColor = Color.Red
                }
            
            case .soon:
                self.lblBadge.isHidden = false
                self.lblBadge.text = Constants.Strings.Soon.uppercased()
                self.imgIcon.tintColor = Color.Gray
                self.lblTitle.textColor = Color.Gray
                self.lblBadge.backgroundColor = Color.Gray
        }
    }
}
