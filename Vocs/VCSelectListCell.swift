//
//  VCSelectListCell.swift
//  
//
//  Created by Mathis Delaunay on 31/10/2017.
//

import UIKit

class VCSelectListCell: UITableViewCell {
    
    var labelListe : UILabel = {
        let label = UILabel()
        label.text = "Overflow"
        label.font = UIFont(name: "Helvetica-Light", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let separatorLine : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 149/255, green: 152/255, blue: 154/255, alpha: 0.5)
        view.alpha = 0.5
        return view
    }()
    
    let switchView : VCSwitchInCell = {
        let switchView = VCSwitchInCell()
        switchView.transform = CGAffineTransform(translationX: 0, y: 7)
        switchView.onTintColor = UIColor(r: 0, g: 188, b: 158)
        return switchView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        setupViews()
    }
    
    func isSelected() -> Bool {
        return switchView.isOn
    }
    
    func setText(text : String) {
        labelListe.text = text
    }
    
    func setupViews() {
        self.addSubview(switchView)
        
        switchView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        switchView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        switchView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier : 2/10).isActive = true
        switchView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        self.addSubview(labelListe)
        
        labelListe.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        labelListe.leftAnchor.constraint(equalTo: self.switchView.rightAnchor).isActive = true
        labelListe.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        labelListe.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier : 8/10).isActive = true
        
        self.addSubview(separatorLine)
        
        separatorLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant : 1).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

