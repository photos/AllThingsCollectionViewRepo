//
//  SectionHeaderView.swift
//  News
//
//  Created by Forrest Collins on 1/11/16.
//  Copyright © 2016 helloTouch. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    
    //-------------------
    // MARK: - UI Outlets
    //-------------------
    @IBOutlet weak var sectionLabel: UILabel!
    
    var publisher: Publisher? {
        didSet {
            sectionLabel.text = publisher?.section.uppercaseString
        }
    }
}
