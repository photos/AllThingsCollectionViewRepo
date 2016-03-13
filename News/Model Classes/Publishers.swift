//
//  Publishers.swift
//  News
//
//  Created by Forrest Collins on 1/11/16.
//  Copyright © 2016 helloTouch. All rights reserved.
//

import UIKit

class Publishers
{
    private var publishers = [Publisher]()
    private var immutablePublishers = [Publisher]()
    private var sections = [String]()
    
    var numberOfPublishers: Int {
        return publishers.count
    }
    
    var numberOfSections: Int {
        return sections.count
    }
    
    //------------------------------
    // MARK: - Initialize Publishers
    //------------------------------
    init()
    {
        publishers = createPublishers()
        immutablePublishers = publishers
        sections = ["My Favorites", "Politics", "Travel", "Technology"]
    }
    
    // * Public Functions *
    
    //------------------------------------
    // MARK: - Delete Items at Index Paths
    //------------------------------------
    func deleteItemsAtIndexPaths(indexPaths: [NSIndexPath])
    {
        var indexes = [Int]()
        for indexPath in indexPaths {
            indexes.append(absoluteIndexForIndexPath(indexPath))
        }
        var newPublishers = [Publisher]()
        for (index, publisher) in publishers.enumerate() {
            if !indexes.contains(index) {
                newPublishers.append(publisher)
            }
        }
        publishers = newPublishers
    }
    
    //---------------------------------------
    // MARK: - Move Publisher from Index Path
    //---------------------------------------
    func movePublisherFromIndexPath(indexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath) {
        if indexPath != newIndexPath {
            let index = absoluteIndexForIndexPath(indexPath)
            let publisher = publishers[index]
            publisher.section = sections[newIndexPath.section]
            let newIndex = absoluteIndexForIndexPath(newIndexPath)
            publishers.removeAtIndex(index)
            publishers.insert(publisher, atIndex: newIndex)
        }
    }
    
    //--------------------------------------------
    // MARK: - Index Path for New Random Publisher
    //         for creating a new random publisher
    //--------------------------------------------
    func indexPathForNewRandomPublisher() -> NSIndexPath
    {
        let index = Int(arc4random_uniform(UInt32(immutablePublishers.count)))
        let publisherToCopy = immutablePublishers[index]
        let newPublisher = Publisher(copies: publisherToCopy)
        publishers.append(newPublisher)
        publishers.sortInPlace { $0.section < $1.section }
        return indexPathForPublisher(newPublisher)
    }
    
    //---------------------------------
    // MARK: - Index Path for Publisher
    //---------------------------------
    func indexPathForPublisher(publisher: Publisher) -> NSIndexPath
    {
        let section = sections.indexOf(publisher.section)
        var item = 0
        for (index, currentPublisher) in publishersForSection(section!).enumerate() {
            if currentPublisher === publisher {
                item = index
                break
            }
        }
        return NSIndexPath(forItem: item, inSection: section!)
    }
    
    //----------------------------------------
    // MARK: - Number of Publishers in Section
    //----------------------------------------
    func numberOfPublishersInSection(index: Int) -> Int {
        let publishers = publishersForSection(index)
        return publishers.count
    }
    
    //-----------------------------------------
    // MARK: - Publisher for Item at Index Path
    //-----------------------------------------
    func publisherForItemAtIndexPath(indexPath: NSIndexPath) -> Publisher? {
        if indexPath.section > 0 {
            let publishers = publishersForSection(indexPath.section)
            return publishers[indexPath.item]
        } else {
            return publishers[indexPath.item]
        }
    }
    
    //----------------------------------------
    // MARK: - Title for Section at Index Path
    //----------------------------------------
    func titleForSectionAtIndexPath(indexPath: NSIndexPath) -> String?
    {
        if indexPath.section < sections.count {
            return sections[indexPath.section]
        }
        return nil
    }
    
    // * Private Functions *
    
    //--------------------------
    // MARK: - Create Publishers
    //--------------------------
    private func createPublishers() -> [Publisher]
    {
        var newPublishers = [Publisher]()
        newPublishers += MyFavorites.publishers()
        newPublishers += Politics.publishers()
        newPublishers += Travel.publishers()
        newPublishers += Technology.publishers()
        return newPublishers
    }
    
    //--------------------------------------
    // MARK: - Absolute Index for Index Path
    //--------------------------------------
    private func absoluteIndexForIndexPath(indexPath: NSIndexPath) -> Int
    {
        var index = 0
        for i in 0..<indexPath.section {
            index += numberOfPublishersInSection(i)
        }
        index += indexPath.item
        return index
    }
    
    //-------------------------------
    // MARK: - Publishers for Section
    //-------------------------------
    private func publishersForSection(index: Int) -> [Publisher] {
        let section = sections[index]
        let publishersInSection = publishers.filter {
            (publisher: Publisher) -> Bool in return publisher.section == section
        }
        return publishersInSection
    }
}

//------------------------------------------------------------
// MARK: - Classes for News Categories holding Publishers Data
//------------------------------------------------------------
class MyFavorites
{
    class func publishers() -> [Publisher]
    {
        var publishers = [Publisher]()
        publishers.append(Publisher(title: "TIME", url: "http://time.com", image: UIImage(named: "TIME")!, section: "My Favorites"))
        publishers.append(Publisher(title: "The New York Times", url: "http://www.nytimes.com", image: UIImage(named: "The New York Times")!, section: "My Favorites"))
        publishers.append(Publisher(title: "TED", url: "https://www.ted.com", image: UIImage(named: "TED")!, section: "My Favorites"))
        publishers.append(Publisher(title: "Re/code", url: "http://recode.net", image: UIImage(named: "Recode")!, section: "My Favorites"))
        publishers.append(Publisher(title: "WIRED", url: "http://www.wired.com", image: UIImage(named: "WIRED")!, section: "My Favorites"))
        return publishers
    }
}

class Politics
{
    class func publishers() -> [Publisher]
    {
        var publishers = [Publisher]()
        publishers.append(Publisher(title: "The Atlantic", url: "http://www.theatlantic.com", image: UIImage(named: "The Atlantic")!, section: "Politics"))
        publishers.append(Publisher(title: "The Hill", url: "http://thehill.com", image: UIImage(named: "The Hill")!, section: "Politics"))
        publishers.append(Publisher(title: "Daily Intelligencer", url: "http://nymag.com/daily/intelligencer/", image: UIImage(named: "Daily Intelligencer")!, section: "Politics"))
        publishers.append(Publisher(title: "Vanity Fair", url: "http://www.vanityfair.com", image: UIImage(named: "Vanity Fair")!, section: "Politics"))
        publishers.append(Publisher(title: "TIME", url: "http://time.com", image: UIImage(named: "TIME")!, section: "Politics"))
        publishers.append(Publisher(title: "The Huffington Post", url: "http://www.huffingtonpost.com", image: UIImage(named: "The Huffington Post")!, section: "Politics"))
        return publishers
    }
}

class Travel
{
    class func publishers() -> [Publisher]
    {
        var publishers = [Publisher]()
        publishers.append(Publisher(title: "AFAR", url: "http://www.afar.com", image: UIImage(named: "AFAR")!, section: "Travel"))
        publishers.append(Publisher(title: "The New York Times", url: "http://www.nytimes.com", image: UIImage(named: "The New York Times")!, section: "Travel"))
        publishers.append(Publisher(title: "Men’s Journal", url: "http://www.mensjournal.com", image: UIImage(named: "Men’s Journal")!, section: "Travel"))
        publishers.append(Publisher(title: "Smithsonian", url: "http://www.smithsonianmag.com/?no-ist", image: UIImage(named: "Smithsonian")!, section: "Travel"))
        publishers.append(Publisher(title: "Wallpaper", url: "http://www.wallpaper.com", image: UIImage(named: "Wallpaper")!, section: "Travel"))
        publishers.append(Publisher(title: "Sunset", url: "http://www.sunset.com", image: UIImage(named: "Sunset")!, section: "Travel"))
        return publishers
    }
}

class Technology
{
    class func publishers() -> [Publisher]
    {
        var publishers = [Publisher]()
        publishers.append(Publisher(title: "WIRED", url: "http://www.wired.com", image: UIImage(named: "WIRED")!, section: "Technology"))
        publishers.append(Publisher(title: "Re/code", url: "http://recode.net", image: UIImage(named: "Recode")!, section: "Technology"))
        publishers.append(Publisher(title: "Quartz", url: "http://qz.com", image: UIImage(named: "Quartz")!, section: "Technology"))
        publishers.append(Publisher(title: "Daring Fireball", url: "http://daringfireball.net", image: UIImage(named: "Daring Fireball")!, section: "Technology"))
        publishers.append(Publisher(title: "MIT Technology Review", url: "http://www.technologyreview.com", image: UIImage(named: "MIT Technology Review")!, section: "Technology"))
        return publishers
    }
}













