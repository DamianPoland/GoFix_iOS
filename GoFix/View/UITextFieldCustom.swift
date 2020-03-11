//
//  UITextFieldCustom.swift
//  GoFix
//
//  Created by Wolf on 11/03/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit

class UITextFieldCustom: UITextField {

    // initializer if is acces from swift file - pragramically
    override init(frame: CGRect) {
        super.init(frame: frame)
        setShadowTextField()
    }
    // initializer if is acces from storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setShadowTextField()
    }
    
    func setShadowTextField() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.2 // trnansparency
        clipsToBounds = true
        layer.masksToBounds = false
    }

}
