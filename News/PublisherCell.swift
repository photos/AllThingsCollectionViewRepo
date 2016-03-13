//
//  PublisherCell.swift
//  News
//
//  Created by Forrest Collins on 1/11/16.
//  Copyright © 2016 helloTouch. All rights reserved.
//

import UIKit

protocol PublisherCellDelegate {
    
    func deletePublisher(publisher: Publisher)
}

class PublisherCell: UICollectionViewCell {
    
    //-------------------
    // MARK: - UI Outlets
    //-------------------
    @IBOutlet weak var publisherImageView: UIImageView!
    @IBOutlet weak var publisherTitleLabel: UILabel!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var closeButtonView: UIVisualEffectView!
    
    var delegate: PublisherCellDelegate?
    
    // whenever a publisher is set, update the UI because the name may be really long
    var publisher: Publisher? {
        didSet {
            updateUI()
        }
    }
    
    // Are we in editing mode or not
    var editing: Bool = false {
        // show close button
        didSet {
            closeButtonView.hidden = !editing
        }
    }
    
    //-------------------------------------------------------------------------
    // MARK: - Delete Button Tapped
    //         when the user clicks delete button, the PublisherCell gets 
    //         notified. The cell will tell the delegate to delete a publisher.
    //-------------------------------------------------------------------------
    @IBAction func deleteButtonTapped() {
        delegate?.deletePublisher(publisher!)
    }

    //------------------
    // MARK: - Update UI
    //------------------
    func updateUI() {
    
        // set image & title of cell
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 3.0
        publisherImageView.image = publisher?.image
        publisherTitleLabel.text = publisher?.title
        
        closeButtonView.layer.masksToBounds = true
        closeButtonView.layer.cornerRadius = closeButtonView.bounds.width/2
    }
    
    //---------------------------------------------------
    // MARK: - Snapshot for Dragging Collection View Item
    //---------------------------------------------------
    var snapshot: UIView {
        get {
            let snapshot = snapshotViewAfterScreenUpdates(true)
            // add shadow to create sense of depth when picking up cell
            let layer = snapshot.layer
            layer.masksToBounds = false
            layer.shadowOffset = CGSize(width: -2.5, height: 0.0)
            layer.shadowRadius = 3.0
            layer.shadowOpacity = 0.4
            
            return snapshot // which is a UIView
        }
    }
    
    // when true, hide the current cell
    var dragging: Bool = false {
        didSet {
            let alpha: CGFloat = dragging ? 0.0 : 1.0
            publisherImageView.alpha = alpha
            publisherTitleLabel.alpha = alpha
            visualEffectView.alpha = alpha
        }
    }
}