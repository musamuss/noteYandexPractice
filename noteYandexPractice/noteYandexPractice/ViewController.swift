//
//  ViewController.swift
//  noteYandexPractice
//
//  Created by Admin on 22/06/2019.
//  Copyright © 2019 musamuss. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var colorsBar: ColorsBarView!
    @IBOutlet weak var colorPicker: ColorPicker!
    @IBOutlet weak var dateSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    //@IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func dateSwitchClick(_ sender: UISwitch) {
        // creepy animation
        UIView.animate(withDuration: 0.3, animations: {
            self.datePicker.isHidden.toggle()
        })
        //        datePicker.isHidden.toggle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeybordShowObservers()
        setupClickHandlers()
    }
    
    private func setupClickHandlers() {
        colorsBar.clickHandler = {color in
            guard color != nil else {
                return
            }
            self.updateNoteColor(withColor: color!)
        }
    
        colorsBar.longPressHandler = {color in
            if color == ClickEvents.custom {
                self.showColorPicker()
            }
        }
        
        colorPicker.willhideWith = {color in
            self.hideColorPicker()
            self.updateNoteColor(withColor: color)
            self.colorsBar.colorCustom.noteColor = color
            self.colorsBar.colorCustom.isColorSelected = true
            self.colorsBar.switchSelected(ClickEvents.custom)
        }
    }
    
    private func showColorPicker() {
        self.view.endEditing(true)
        colorPicker.isHidden = false
        scrollView.isHidden = true
    }
    
    private func hideColorPicker() {
        colorPicker.isHidden = true
        scrollView.isHidden = false
    }
    
    private func updateNoteColor(withColor color: UIColor) {
        noteTextView.backgroundColor = color
    }
    
    private func setupKeybordShowObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustForKeyboardShow(true, notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustForKeyboardShow(false, notification: notification)
    }
    
    func adjustForKeyboardShow(_ show: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let kbFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let kbEndFrame = view.convert(kbFrame, from: view.window)
        if show {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbEndFrame.height, right: 0)
        } else {
            scrollView.contentInset = UIEdgeInsets.zero
        }
        
    }
    
}
