//
//  UIButtonCustom.swift
//  GoFix
//
//  Created by Wolf on 11/03/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit

class UIButtonCustom: UIButton {

    // initializer if is acces from swift file - pragramically
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeButton()
    }
    // initializer if is acces from storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customizeButton()
    }
    
    func customizeButton() {
        styleButton() // set button color radius etc.
        setShadowButton() // add efect 3D - not see in dark mode
        //shakeButton() // shake left to right when init or add to view controller and shake when click
    }
    
    func styleButton() {
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(name: "Georgia", size: 20) // eg: "Times New Roman" or "System", size text
        //titleLabel?.font = UIFont.boldSystemFont(ofSize: 20) // bold Font - can be others
        contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0) // add padding
        backgroundColor = #colorLiteral(red: 0.05098039216, green: 0.2784313725, blue: 0.631372549, alpha: 1) // add backgroud color
        layer.cornerRadius = 15 // corners
        //layer.borderWidth = 3.0 // add bordr
        //layer.borderColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)// border color
    }
    
    func setShadowButton() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5 // trnansparency
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    func shakeButton() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1 // time of one shake
        shake.repeatCount = 2 // number of shakes
        shake.autoreverses = true
        let fromPoint = CGPoint(x: center.x - 8, y: center.y) // distance shake from center
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: center.x + 8, y: center.y)// distance shake from center
        let toValue = NSValue(cgPoint: toPoint)
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: "position")
    }
}
