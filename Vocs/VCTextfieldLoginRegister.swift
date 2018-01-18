//
//  VCTextfieldLoginRegister.swift
//  Vocs
//
//  Created by Mathis Delaunay on 14/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import SwifterSwift

class VCTextfieldLoginRegister : UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    func checkIfNotEmpty() -> Bool {
        guard let count = self.text?.count else {return false}
        if count > 0 {
            return true
        } else {
            //Use extension SwifterSwift
            self.shake()
            return false
        }
    }
    
    func checkIfValidEmail() -> Bool {
        guard let text = self.text else {return false}
        if (checkIfNotEmpty() && text.isEmail) {
            return true
        } else {
            //Use extension SwifterSwift
            self.shake()
            return false
        }
    }
    
    func setupTextField() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.textColor = UIColor.black
    }
    
    init(placeholder : String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setupTextField()
        self.placeholder = placeholder
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
