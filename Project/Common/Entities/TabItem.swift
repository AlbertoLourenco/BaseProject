//
//  TabItem.swift
//

import UIKit

struct TabItem {
    var title: String = ""
    var image: UIImage?
    var imageSelected: UIImage?
    var status: TabItemType = .free
    var container: ContainerType = .home
}
