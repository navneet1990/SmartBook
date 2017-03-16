//
//  Extensions.swift
//  MyPhoneBook
//
//  Created by iTexico on 3/12/17.
//  Copyright © 2017 Navneet. All rights reserved.
//

import Foundation
import UIKit
extension UIImageView {
    public func imageFromData(data: NSData?) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let newData = data as? Data , newData.count > 50
                else{
                    
                 return
            }
            
        let images = UIImage(data:  data! as Data)

            DispatchQueue.main.async { () -> Void in
                
                self.image = images
            }
    }
    }
}

extension UITextField{
    func givePaddingInTextField() {
        
        let padView: UIView = UIView(frame: CGRect.init(x: 0, y: 0, width: 15, height: 40))
        self.leftView = padView;
        self.leftViewMode = UITextFieldViewMode.always;
    }
    
    func isValidEmail()-> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text)
    }
    func removeWhiteSpaceFromTextField(){
        self.text = self.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
    }
}

extension String{
    func isValidEmail()-> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    mutating func removeWhiteSpace(){
        self = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
    }
}
