//
//  NoteTableViewCell.swift
////  noteYandexPractice
////
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
////

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
