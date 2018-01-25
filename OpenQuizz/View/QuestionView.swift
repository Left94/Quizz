//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by vincent  on 22/01/2018.
//  Copyright © 2018 Loret Vincent. All rights reserved.
//

import UIKit

class QuestionView: UIView {

   @IBOutlet private var label: UILabel!
   @IBOutlet private var icon: UIImageView!
    
    enum Style {
        case correct, incorrect, standard
    }
    
    var style: Style = .standard {
        didSet {
            setStyle(style)
        }
    }
    
    var title = "" {
        didSet {
            label.text = title
        }
    }
    
    private func setStyle(_ style: Style) {
        switch style {
        case .correct:
            backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.8274509804, blue: 0.1294117647, alpha: 1)
            icon.image = #imageLiteral(resourceName: "Icon Correct")
            icon.isHidden = false
        case .incorrect:
            backgroundColor = #colorLiteral(red: 0.9514202476, green: 0.529435277, blue: 0.5806919932, alpha: 1)
            icon.image = #imageLiteral(resourceName: "Icon Error")
            icon.isHidden = false
        case .standard:
            backgroundColor = #colorLiteral(red: 0.7502701879, green: 0.7679536343, blue: 0.7878373861, alpha: 1)
            icon.isHidden = true
        }
    }

}
