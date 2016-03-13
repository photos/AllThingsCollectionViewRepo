//
//  PublishersFlowLayout.swift
//  News
//
//  Created by Forrest Collins on 1/11/16.
//  Copyright © 2016 helloTouch. All rights reserved.
//

import UIKit

class PublisherFlowLayout: UICollectionViewFlowLayout {
    
    // hold the index path of the item being inserted
    var appearingIndexPath: NSIndexPath?
    
    // hold the index paths of the items being deleted
    var disappearingIndexPaths: [NSIndexPath]?
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initial Layout Attributes for Appearing Item at Index Path, for Inserting Items
    //         gives out an array of attributes of a cell inside a collectionView
    //         every time a new cell is dequed, this method gets called
    //         this method provides the layout with the initial layout attributes for items being 
    //         inserted into collection view.
    //-------------------------------------------------------------------------------------------
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        // a set of layout attributes for the item at the given index path
        // these are the default attributes
        let attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        
        // we will manipulate them if teh index path matches the index path of the item being inserted
        if let appearingIndexPath = appearingIndexPath { // unwrap the appearing index path
            if appearingIndexPath == itemIndexPath { // the super method returns optional so also unwraps
                if let attributes = attributes { // check if current inde xpath is teh same as one inserted
                    
                    // update the item position, scale...
                    attributes.alpha = 1.0
                    attributes.transform = CGAffineTransformMakeScale(0.15, 0.15) // initially cell is small
                    attributes.zIndex = 99 // make this appear above all items
                    
                }
            }
        }
        
        return attributes // next, we need to tell our collection view to use collection view flow layout
    }
    
    //--------------------------------------------------------------------
    // MARK: - Final Layout Attributes for Disappearing Item at Index Path
    //         change the final state of the declared items' attributes
    //--------------------------------------------------------------------
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        
        if let disappearingIndexPaths = disappearingIndexPaths {
            for indexPath in disappearingIndexPaths {
                if indexPath == itemIndexPath {
                    if let attributes = attributes {
                        
                        attributes.alpha = 0.0
                        attributes.transform = CGAffineTransformMakeScale(0.1, 0.1)
                        attributes.zIndex = -1
                    }
                }
            }
        }
        
        return attributes
    }
}