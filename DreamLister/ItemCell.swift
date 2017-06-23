//
//  ItemCell.swift
//  DreamLister
//
//  Created by Romulo Augusto on 10/06/17.
//  Copyright © 2017 Romulo. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView! 
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    
    // configure a cell
    func configureCell(item: Item) {
        self.title.text = item.title
        self.price.text = "$\(item.price)"
        self.details.text = item.details
        self.thumb.image = item.toImage?.image as? UIImage
    }
}
