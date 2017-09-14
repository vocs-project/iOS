//
//  VCViewWithoutTextField.swift
//  Vocs
//
//  Created by Mathis Delaunay on 12/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCViewConnectionWithTextField : VCViewConnectionWithoutTextField {
    
    
    var textField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Textfield"
        return tf
    }()
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        setupViews()
    }
    
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
