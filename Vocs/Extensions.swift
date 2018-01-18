//
//  Extensions.swift
//  Vocs
//
//  Created by Mathis Delaunay on 04/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import UIKit
import Security

extension UIColor {
    convenience init(r : CGFloat, g : CGFloat,b :CGFloat){
        self.init(red: r / 255, green:  g / 255, blue: b / 255, alpha: 1)
    }
}

extension UIViewController {
    func setBackgroundImage() {
        UIGraphicsBeginImageContext(self.view.frame.size)
        #imageLiteral(resourceName: "BackgroundConnexion").draw(in: self.view.bounds)
        
        if let image: UIImage = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image non disponible")
        }
    }
}

extension UIViewController {
    func presentError(title : String, message : String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Retour", style: UIAlertActionStyle.cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func presentConfirmation(title : String, message : String, handleConfirm : @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Retour", style: UIAlertActionStyle.cancel)
        let confirmationAction = UIAlertAction(title: "Confirmer", style: .default) { (alertAction) in
            handleConfirm()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmationAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Rouge invalide")
        assert(green >= 0 && green <= 255, "Vert invalide")
        assert(blue >= 0 && blue <= 255, "Bleu invalide")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIView {
    func addSubviews(_ views : [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}

extension Sequence where Iterator.Element == UIView
{
    func removeFromSuperviews() {
        for view in self {
            view.removeFromSuperview()
        }
    }
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}


extension String {
    func isDecimal() -> Bool {
        return Int(self) == nil ? false : true
    }
    func supprimerParentheseEtEspaces() -> String {
        var word = self.lowercased()
        var offset = 0
        var supprimer = false
        for letter in word {
            if letter == "(" {
                supprimer = true
            }
            if supprimer {
                word.remove(at: word.index(word.startIndex, offsetBy: offset))
                if letter == ")" {
                    supprimer = false
                }
            } else {
                offset += 1
            }
        }
        return word.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func presentRightToLeft(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UIViewController { //Permet quand on tape ailleurs -> plus de clavier
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// Extension used for constraints
// You will not be obliged to define translatesAutoresizingMaskIntoConstraints = false ( Defined in setConstraints )
extension UIView {
    
    //Function used by all the others
    
    private func setConstraints(top : NSLayoutYAxisAnchor? ,constantTop: CGFloat , bottom : NSLayoutYAxisAnchor? ,constantBottom : CGFloat ,left : NSLayoutXAxisAnchor?,constantLeft: CGFloat, right : NSLayoutXAxisAnchor?, constantRight: CGFloat, centerX: NSLayoutXAxisAnchor?, constantX : CGFloat,centerY: NSLayoutYAxisAnchor?, constantY : CGFloat,width : NSLayoutDimension?, multiplierWidth : CGFloat, constantWidth : CGFloat,height : NSLayoutDimension?, multiplierHeight : CGFloat, constantHeight : CGFloat)  {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if top != nil {
            self.topAnchor.constraint(equalTo: top!,constant: constantTop).isActive = true
        }
        if bottom != nil {
            self.bottomAnchor.constraint(equalTo: bottom!,constant: constantBottom).isActive = true
        }
        if left != nil {
            self.leftAnchor.constraint(equalTo: left!,constant: constantLeft).isActive = true
        }
        if right != nil {
            self.rightAnchor.constraint(equalTo: right!,constant: constantRight).isActive = true
        }
        if centerX != nil {
            self.centerXAnchor.constraint(equalTo: centerX!,constant: constantX).isActive = true
        }
        if centerY != nil {
            self.centerYAnchor.constraint(equalTo: centerY!,constant: constantY).isActive = true
        }
        if width != nil {
            let layoutConstraintWidth = self.widthAnchor.constraint(equalTo: width!,multiplier : multiplierWidth)
            layoutConstraintWidth.constant = constantWidth
            layoutConstraintWidth.isActive = true
        }
        if height != nil {
            let layoutConstraintHeight = self.heightAnchor.constraint(equalTo: height!,multiplier : multiplierHeight)
            layoutConstraintHeight.constant = constantHeight
            layoutConstraintHeight.isActive = true
        }
    }
    
    /**
     
     Set constraints for top, bottom, left and right ( TBLR )
     
     */
    
    func setConstraintsTBLR(top : NSLayoutYAxisAnchor ,constantTop: CGFloat , bottom : NSLayoutYAxisAnchor ,constantBottom : CGFloat ,left : NSLayoutXAxisAnchor,constantLeft: CGFloat, right : NSLayoutXAxisAnchor, constantRight: CGFloat)  {
        self.setConstraints(top: top, constantTop: constantTop, bottom: bottom, constantBottom: constantBottom, left: left, constantLeft: constantLeft, right: right, constantRight: constantRight, centerX: nil, constantX: 0, centerY: nil, constantY: 0, width: nil, multiplierWidth: 0, constantWidth: 0, height: nil, multiplierHeight: 0, constantHeight: 0)
    }
    
    /**
     
     Set constraints for centerX, centerY, width and height ( XYWH )
     
     */
    
    func setConstraintsXYWH(centerX: NSLayoutXAxisAnchor, constantX : CGFloat,centerY: NSLayoutYAxisAnchor, constantY : CGFloat,width : NSLayoutDimension, multiplierWidth : CGFloat, constantWidth : CGFloat,height : NSLayoutDimension, multiplierHeight : CGFloat, constantHeight : CGFloat)  {
        self.setConstraints(top: nil, constantTop: 0, bottom: nil, constantBottom: 0, left: nil, constantLeft: 0, right: nil, constantRight: 0, centerX: centerX, constantX: constantX, centerY: centerY, constantY: constantY, width: width, multiplierWidth: multiplierWidth, constantWidth: constantWidth, height: height, multiplierHeight: multiplierHeight, constantHeight: constantHeight)
    }
    
    /**
     
     Set constraints for centerY, left, width and height ( YLWH )
     
     */
    
    func setConstraintsYLWH(centerY: NSLayoutYAxisAnchor, constantY: CGFloat, left: NSLayoutXAxisAnchor, constantLeft: CGFloat,width : NSLayoutDimension, multiplierWidth : CGFloat, constantWidth : CGFloat,height : NSLayoutDimension, multiplierHeight : CGFloat, constantHeight : CGFloat ) {
        self.setConstraints(top: nil, constantTop: 0, bottom: nil, constantBottom: 0, left: left, constantLeft: constantLeft, right: nil, constantRight: 0, centerX: nil, constantX: 0, centerY: centerY, constantY: constantY, width: width, multiplierWidth: multiplierWidth, constantWidth: constantWidth, height: height, multiplierHeight: multiplierHeight, constantHeight: constantHeight)
    }
    
    /**
     
     Set constraints for centerY , right , width and height ( YRWH )
     
     */
    
    func setConstraintsYRWH(centerY: NSLayoutYAxisAnchor, constantY: CGFloat, right: NSLayoutXAxisAnchor, constantRight: CGFloat,width : NSLayoutDimension, multiplierWidth : CGFloat, constantWidth : CGFloat,height : NSLayoutDimension, multiplierHeight : CGFloat, constantHeight : CGFloat ) {
        self.setConstraints(top: nil, constantTop: 0, bottom: nil, constantBottom: 0, left: nil, constantLeft: 0, right: right, constantRight: constantRight, centerX: nil, constantX: 0, centerY: centerY, constantY: constantY, width: width, multiplierWidth: multiplierWidth, constantWidth: constantWidth, height: height, multiplierHeight: multiplierHeight, constantHeight: constantHeight)
    }
    
    /**
     
     Set constraints for left , top , width and height ( LTWH )
     
     */
    
    func setConstraintsLTWH(left: NSLayoutXAxisAnchor, constantLeft: CGFloat , top: NSLayoutYAxisAnchor, constantTop: CGFloat,width : NSLayoutDimension, multiplierWidth : CGFloat, constantWidth : CGFloat,height : NSLayoutDimension, multiplierHeight : CGFloat, constantHeight : CGFloat ) {
        self.setConstraints(top: top, constantTop: constantTop, bottom: nil, constantBottom: 0, left: left, constantLeft: constantLeft, right: nil, constantRight: 0, centerX: nil, constantX: 0, centerY: nil, constantY: 0, width: width
            , multiplierWidth: multiplierWidth, constantWidth: constantWidth, height: height, multiplierHeight: multiplierHeight, constantHeight: constantHeight)
    }
    
    
    /**
     
     Set constraints for right , top , width and height ( RTWH )
     
     */
    
    func setConstraintsRTWH(right: NSLayoutXAxisAnchor, constantRight: CGFloat , top: NSLayoutYAxisAnchor, constantTop: CGFloat,width : NSLayoutDimension, multiplierWidth : CGFloat, constantWidth : CGFloat,height : NSLayoutDimension, multiplierHeight : CGFloat, constantHeight : CGFloat ) {
        self.setConstraints(top: top, constantTop: constantTop, bottom: nil, constantBottom: 0, left: nil, constantLeft: 0, right: right, constantRight: constantRight, centerX: nil, constantX: 0, centerY: nil, constantY: 0, width: width
            , multiplierWidth: multiplierWidth, constantWidth: constantWidth, height: height, multiplierHeight: multiplierHeight, constantHeight: constantHeight)
    }
    
    
    /**
     
     Set constraints for right , bottom , width and height ( RBWH )
     
     */
    
    
    
    
    func setConstraintsRBWH(right: NSLayoutXAxisAnchor, constantRight: CGFloat , bottom: NSLayoutYAxisAnchor, constantBottom: CGFloat,width : NSLayoutDimension, multiplierWidth : CGFloat, constantWidth : CGFloat,height : NSLayoutDimension, multiplierHeight : CGFloat, constantHeight : CGFloat) {
        self.setConstraints(top: nil, constantTop: 0, bottom: bottom, constantBottom: constantBottom, left: nil, constantLeft: 0, right: right, constantRight: constantRight, centerX: nil, constantX: 0, centerY: nil, constantY: 0, width: width
            , multiplierWidth: multiplierWidth, constantWidth: constantWidth, height: height, multiplierHeight: multiplierHeight, constantHeight: constantHeight)
    }
    
    /**
     
     Set constraints for left , bottom , width and height ( LBWH )
     
     */
    
    
    func setConstraintsLBWH(left: NSLayoutXAxisAnchor, constantLeft: CGFloat , bottom: NSLayoutYAxisAnchor, constantBottom: CGFloat,width : NSLayoutDimension, multiplierWidth : CGFloat, constantWidth : CGFloat,height : NSLayoutDimension, multiplierHeight : CGFloat, constantHeight : CGFloat) {
        self.setConstraints(top: nil, constantTop: 0, bottom: bottom, constantBottom: constantBottom, left: left, constantLeft: constantLeft, right: nil, constantRight: 0, centerX: nil, constantX: 0, centerY: nil, constantY: 0, width: width
            , multiplierWidth: multiplierWidth, constantWidth: constantWidth, height: height, multiplierHeight: multiplierHeight, constantHeight: constantHeight)
    }
    /**
     
     Set constraints for top , centerX , width and height ( TXWH )
     
     */
    
    
    func setConstraintsTXWH(top: NSLayoutYAxisAnchor, constantTop: CGFloat , center: NSLayoutXAxisAnchor, constantCenter: CGFloat,width : NSLayoutDimension, multiplierWidth : CGFloat, constantWidth : CGFloat,height : NSLayoutDimension, multiplierHeight : CGFloat, constantHeight : CGFloat) {
        self.setConstraints(top: top, constantTop: constantTop, bottom: nil, constantBottom: 0, left: nil, constantLeft: 0, right: nil, constantRight: 0, centerX: center, constantX: constantCenter, centerY: nil, constantY: 0, width: width
            , multiplierWidth: multiplierWidth, constantWidth: constantWidth, height: height, multiplierHeight: multiplierHeight, constantHeight: constantHeight)
    }
}
