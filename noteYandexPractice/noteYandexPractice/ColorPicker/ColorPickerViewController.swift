//
//  ColorPickerViewController.swift
//  noteYandexPractice
//
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {

    @IBOutlet weak var colorPicker: ColorPicker!
    var mainViewController: EditNote?
    var color: CGColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        colorPicker.set(Color: color ?? UIColor.white.cgColor)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mainViewController?.colorSelectableView.Color = colorPicker.getColor() // get current color
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
