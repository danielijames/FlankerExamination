//
//  ViewController.swift
//  FlankerExamination
//
//  Created by Daniel James on 12/7/19.
//  Copyright © 2019 Dom.Inspiration. All rights reserved.
//

import UIKit
/*
 This is the login view controller
 */

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var inputID: UITextField!
    var ID: Int = 0
 

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.transform = CGAffineTransform(translationX: 0, y: -100)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let result = textField.text?.count == 5 ? true : false
        switch result {

        case true:
            startGameButton.isEnabled = true
            startGameButton.tintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            self.ID = Int(textField.text!)!
            print(self.ID)
            return true
        default:
            startGameButton.isEnabled = false
            startGameButton.tintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            return true
        }
    }


    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        inputID.inputAccessoryView = doneToolbar
    }

    
    
    @objc func doneButtonAction(){
        self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        inputID.resignFirstResponder()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addDoneButtonOnKeyboard()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.startGameButton.isEnabled = false
        let destinationVC = segue.destination as! schoolViewController
        destinationVC.ID = self.ID
    }
    


}

