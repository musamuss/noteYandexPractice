//
//  ViewController.swift
////  noteYandexPractice
////
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
////

import UIKit
import CocoaLumberjack

class NoteCardViewController: UIViewController {
    
    var notebook: FileNotebook?
    var note: Note?
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var destroyDateSwitch: UISwitch!
    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    @IBOutlet weak var colorSelector: ColorSelector!
    @IBOutlet weak var destroyDatePickerHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var mainContent: UIScrollView!
    //@IBOutlet weak var mainView: UIView!
    
    @IBAction func unwindToStartScreen(segue: UIStoryboardSegue ){
        
    }
    
    @IBAction func changeDestroyDateSwitch(_ sender: UISwitch) {
        updateUI()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DDLogDebug("NoteCardViewController load")
        contentTextField.layer.borderColor = UIColor.red.cgColor
        contentTextField.layer.borderWidth = 1.0
        self.titleTextField.delegate = self
        self.contentTextField.delegate = self
        //
        destroyDatePicker.minimumDate = Date()
        
        colorSelector.colorSelectHandler = { [weak self] color in
            self?.colorSelected(color: color)
        }
        colorSelector.customColorSelectHandler = { [weak self] in
            self?.selectCustomColor()
        }
        
        contentTextField.delegate = self
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let note = note {
            titleTextField.text = note.title
            contentTextField.text = note.content
            colorSelector.setColor(note.color)
           
            destroyDateSwitch.isOn = note.destroyAt != nil
        }
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        titleTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        saveNote()
        print("disappear \(String(describing: note))")
        
    }
    
    func setDataOutside(color: UIColor, noteOut: Note){
        DDLogDebug("setColorOutside \(color)")
        note = noteOut
        
        colorSelector.customColor = color
        colorSelector.setColor(color)
        note?.color = color
    }
    
    func textViewDidChange(_ textView: UITextView){
        print(textView)
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ColorPickerViewController,
            segue.identifier == "ColorPickSegue" {
        
            controller.noteController = self
            saveNote()
            controller.note = self.note
        }
    }
    
    private func saveNote(){
        
        note?.title = titleTextField.text!
        note?.content = contentTextField.text!
        note?.destroyAt = destroyDateSwitch.isOn ? destroyDatePicker.date : nil
        note?.color = colorSelector.currentColor
        notebook?.newNote = note
        
    }
    
    
    private func selectCustomColor(){
        DDLogDebug("selectCustomColor")
        performSegue(withIdentifier: "ColorPickSegue", sender: nil)
    }
    
    private func colorSelected(color: UIColor){
        
        DDLogDebug("colorSelected notes \(color)")
    }
    
    func updateUI(){
        let showDatePicker = destroyDateSwitch.isOn
        destroyDatePicker.isHidden = !showDatePicker
       let destroyDatePickerHeightFloat = CGFloat(showDatePicker ? 216 : 0)
        destroyDatePickerHeight.constant = destroyDatePickerHeightFloat

        contentTextField.translatesAutoresizingMaskIntoConstraints = true
       contentTextField.sizeToFit()
//        if contentTextField.frame.height <= 90 {
//            let rect = CGRect(x: contentTextField.frame.minX, y: contentTextField.frame.minY, width: contentTextField.frame.width, height: CGFloat(90))
//            contentTextField.frame = rect
//        }
        contentTextField.isScrollEnabled = false

    }
    
}

extension NoteCardViewController : UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == titleTextField){
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    
}

