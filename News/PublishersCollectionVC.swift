//
//  PublishersCollectionVC.swift
//  News
//
//  Created by Forrest Collins on 1/11/16.
//  Copyright © 2016 helloTouch. All rights reserved.
//

import UIKit

class PublishersCollectionVC: UICollectionViewController, PublisherCellDelegate {
    
    //-------------------
    // MARK: - UI Outlets
    //-------------------
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // instantiate data source
    let publishers = Publishers() 
    
    // Variables for Cell dimensions
    private let leftAndRightPaddings: CGFloat = 32.0 // there's 4 horiz. spaces between images, so 8pt * 4 = 32.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    private let heightAdjustment: CGFloat = 30.0 
    
    //----------------------
    // MARK: - View Did Load
    //----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout Dimensions for Cells
        let width = (CGRectGetWidth(collectionView!.frame) - leftAndRightPaddings) / numberOfItemsPerRow
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(width, width + heightAdjustment) // height is longer than the width
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Add a long press gesture to move cell around
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        collectionView?.addGestureRecognizer(longPressGestureRecognizer)
        
    }
    
    //-------------------------------------------------
    // MARK: - Set Editing, Delete Items
    //         If we're in editing mode, we show 
    //         the close button, else hide close button
    //-------------------------------------------------
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // disable add button when in editing mode
        addButton.enabled = !editing
        // find indexPaths for visible items
        if let indexPaths = collectionView?.indexPathsForVisibleItems() {
            // enumerate all indexPaths and change editing property of cell
            for indexPath in indexPaths {
                collectionView?.deselectItemAtIndexPath(indexPath, animated: false)
                let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! PublisherCell
                cell.editing = editing
                cell.delegate = self
            }
        }
    }
    
    //------------------------------------------
    // MARK: - Delete Publisher
    //         Implement when using protocol.
    //         Delete publisher from datasource
    //         then call deleteItemsAtIndexPaths
    //------------------------------------------
    func deletePublisher(publisher: Publisher) {
        
        // 1. delete publisher from datasource
        let indexPath = publishers.indexPathForPublisher(publisher)
        publishers.deleteItemsAtIndexPaths([indexPath]) // delete from publishers
        
        let layout = collectionViewLayout as! PublisherFlowLayout
        layout.disappearingIndexPaths = [indexPath]

        // 2. collectionView.deleteItemsAtIndexPaths([indexPath])
        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: {
            self.collectionView?.deleteItemsAtIndexPaths([indexPath]) // delete from collectionView
            }, completion: { finished in
                layout.disappearingIndexPaths = nil
        })
    }
    
    //--------------------------
    // MARK: - Add Button Tapped
    //         Add More Items
    //--------------------------
    @IBAction func addButtonTapped(sender: AnyObject) {
        
        // 1. Insert new item into datasource
        // returns indexPath for new publisher and adds into datasource
        let indexPath = publishers.indexPathForNewRandomPublisher()
        
        // grab layout object of this collectionView
        let layout = collectionViewLayout as! PublisherFlowLayout
        layout.appearingIndexPath = indexPath
        
        // 2. call insert items at indexPaths b/c of nice animation & user won't have to scroll back
        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: {
            
                self.collectionView?.insertItemsAtIndexPaths([indexPath])
            }, completion: { finished in
                // reset appearing indexPath of layout object after completion
                layout.appearingIndexPath = nil
        })
    }
    
    //---------------------------------------------
    // MARK: - Number of Sections in Collection View
    //---------------------------------------------
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return publishers.numberOfSections
    }
    
    //-----------------------------------
    // MARK: - Number of Items in Section
    //-----------------------------------
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return publishers.numberOfPublishersInSection(section)
    }
    
    // Create one instance of each identifier
    private struct StoryboardConstants {
        static let CellIdentifier = "PublisherCell"
        static let showWebView = "ShowWebView"
    }
    
    //------------------------------------
    // MARK: - Cell for Item at Index Path
    //------------------------------------
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(StoryboardConstants.CellIdentifier, forIndexPath: indexPath) as! PublisherCell
        
        cell.publisher = publishers.publisherForItemAtIndexPath(indexPath)
        cell.editing = editing
        
        return cell
    }
    
    //-----------------------------------------------
    // MARK: - View for Supplementary Element of Kind
    //-----------------------------------------------
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "SectionHeader", forIndexPath: indexPath) as! SectionHeaderView
        
        // if we do have a publisher...
        if let publisher = publishers.publisherForItemAtIndexPath(indexPath) {
            headerView.publisher = publisher
        }
        
        return headerView
    }
    
    //-------------------------------------------------------------
    // MARK: - Did Select Item at Index Path
    //         Whenever a user taps on a cell, then detect that tap
    //-------------------------------------------------------------
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // while in editing mode, disable segues
        if !editing {
            let publisher = publishers.publisherForItemAtIndexPath(indexPath)
            self.performSegueWithIdentifier(StoryboardConstants.showWebView, sender: publisher)
        }
    }
    
    //--------------------------
    // MARK: - Prepare for Segue
    //--------------------------
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  StoryboardConstants.showWebView {
            let webViewController = segue.destinationViewController as! WebViewController
            let publisher = sender as! Publisher
            webViewController.publisher = publisher
        }
    }
    
    //----------------------------------------------------------------
    // MARK: Dragging the Cell
    //       hide the item on long press & create snapshot of the item
    //----------------------------------------------------------------
    private var snapshot: UIView? // reference to snapshot of the current item that we are dragging
    private var sourceIndexPath: NSIndexPath? // indexPah of item being dragged
    
    private func updateSnapshotView(center: CGPoint, transform: CGAffineTransform, alpha: CGFloat) {
        // check if we have a snapshot, then change its UIView properties
        if let snapshot = snapshot {
            snapshot.center = center
            snapshot.transform = transform
            snapshot.alpha = alpha
        }
    }
    
    func longPress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if !editing {
            // get location of longPress if not editing
            // from this location, we can access teh indexPath of the item that we are clicking
            let location = gestureRecognizer.locationInView(collectionView)
            let indexPath = collectionView?.indexPathForItemAtPoint(location)
            
            switch gestureRecognizer.state {
                
                case .Began:
                    print("began")
                    if let indexPath = indexPath {
                        sourceIndexPath = indexPath // update the indexPath
                        let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! PublisherCell
                        snapshot = cell.snapshot
                        updateSnapshotView(cell.center, transform: CGAffineTransformIdentity, alpha: 0.0)
                        collectionView?.addSubview(snapshot!)
                        UIView.animateWithDuration(0.15, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .CurveEaseInOut, animations: {
                            
                            // update the snapshot view to be in center of view & bigger than original size
                            self.updateSnapshotView(cell.center, transform: CGAffineTransformMakeScale(1.05, 1.05), alpha: 0.95)
                            // tell cell that we are dragging it
                            cell.dragging = true
                        }, completion: nil)
                    }
                
                case .Changed:
                    print("changed")
                    // update the center of snapshot, move indexPath order in dataSource & delegate
                    self.snapshot?.center = location
                    if let indexPath = indexPath {
                        // function in Publishers.swift
                        publishers.movePublisherFromIndexPath(sourceIndexPath!, toIndexPath: indexPath)
                        collectionView?.moveItemAtIndexPath(sourceIndexPath!, toIndexPath: indexPath)
                        sourceIndexPath = indexPath
                }
                
                default:
                    print("end")
                    let cell = collectionView?.cellForItemAtIndexPath(sourceIndexPath!) as! PublisherCell
                    UIView.animateWithDuration(0.25, animations: {
                        // hide snapshot and change dragging to false
                        self.updateSnapshotView(cell.center, transform: CGAffineTransformIdentity, alpha: 0.0)
                        cell.dragging = false
                    }, completion: { (finished) -> Void in
                        self.snapshot?.removeFromSuperview()
                        self.snapshot = nil // delete completely
                    })
            }
        }
    }
}
