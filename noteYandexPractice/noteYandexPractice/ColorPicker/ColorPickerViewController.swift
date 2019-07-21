//
//  ColorPickerViewController.swift
////  noteYandexPractice
////
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
////

import UIKit
import CocoaLumberjack

class ColorPickerViewController: UIViewController {

    
    var noteController: NoteCardViewController?
    var note: Note?
    // colorSelector.customColor
    @IBOutlet weak var colorPicker: ColorPickerClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let color = noteController?.colorSelector.customColor {
            colorPicker.currentColor = color
        }
        
        colorPicker.colorSelected = { [weak self] color in
           
            self?.noteController?.setDataOutside(color: color, noteOut: self?.note ?? Note(title: "", content: "", priority: .normal))
            //self?.noteController?.note = self?.note
            //self?.note?.color = color
            DDLogDebug("colorSelected \(color)")
            self?.navigationController?.popViewController(animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
