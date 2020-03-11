//
//  TableViewCellIndustries.swift
//  GoFix
//
//  Created by Wolf on 25/02/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit

class TableViewCellIndustries: UITableViewCell {
    
    
    
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var viewLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class IndustriesToCell {
    var image:UIImage
    var title: String
    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
}

