//
//  ViewController.swift
//  WaitersApp
//
//  Created by Yuriy Sirko on 2/1/16.
//  Copyright © 2016 ThinkMobiles. All rights reserved.
//

import UIKit

class WTSKitchenViewController: UIViewController {
    
    @IBOutlet weak var tablesTableView: UITableView!
    @IBOutlet weak var orderDetailTableView: UITableView!
    @IBOutlet weak var ordersCollectionView: UICollectionView!
    
    var dataSource : [Int] = []
    var currentTableNumber: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareCollectionView()
        prepareDataSource()
    }
    
    // MARK: - IBActions
    
    @IBAction func startButtonTouchUpInside(sender: UIButton) {
        // TODO: select next order
    }
    
    // MARK: - Private Methods
    
    func prepareNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.redApplicationColor()
    }
    
    func prepareCollectionView() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressHandler:")
        ordersCollectionView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func prepareDataSource() {
        // TODO: remove fake data source
        dataSource = [5, 1, 3, 2, 8, 4, 10, 6]
        
        tablesTableView.reloadData()
        ordersCollectionView.reloadData()
        prepareTableView()
    }
    
    func prepareTableView() {
        let path = NSIndexPath.init(forItem: 0, inSection: 0)
        tablesTableView.selectRowAtIndexPath(path, animated: false, scrollPosition: UITableViewScrollPosition.Top)
    }
    
    func longPressHandler(gesture: UILongPressGestureRecognizer) {
        
        let location = gesture.locationInView(ordersCollectionView)
        guard let path = ordersCollectionView.indexPathForItemAtPoint(location),
            let cell = ordersCollectionView.cellForItemAtIndexPath(path) else {
                return
        }
        
        let snapshot = snapshotOfTheView(cell)
        let cellImageView = UIImageView(image: snapshot)
        
        // TODO: drag and drop
        /* switch (gesture.state) {
         case .Began:
         cellImageView.center = location
         self.ordersCollectionView.addSubview(cellImageView)
         case .Changed:
         cellImageView.center = location
         case .Ended:
         cellImageView.removeFromSuperview()
         default:
         break
         }*/
    }
    
    func snapshotOfTheView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot
    }
}

extension WTSKitchenViewController {
    
    private struct Constants {
        static let orderCollectionViewCellTopInset: CGFloat = 20.0
        static let orderCollectionViewCellBottomInset: CGFloat = 18.0
        static let defaultTableViewCellHeight: CGFloat = 120.0
        static let orderCollectionViewCellRatio: CGFloat = 0.725
    }
}

// MARK: - UITableViewDelegate

extension WTSKitchenViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.defaultTableViewCellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentTableNumber = indexPath.row
        ordersCollectionView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension WTSKitchenViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:WTSTableTableViewCell = tableView.dequeueReusableCellWithIdentifier(tableTableViewCellIdentifier, forIndexPath: indexPath) as! WTSTableTableViewCell
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension WTSKitchenViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: return orders count
        return dataSource[currentTableNumber]
    }
}

// MARK: - UICollectionViewDataSource

extension WTSKitchenViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:WTSOrderCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(orderCollectionViewCellIdentifier, forIndexPath: indexPath) as! WTSOrderCollectionViewCell
        return cell
    }
}

// MARK: - UICollectionViewFlowLayout

extension WTSKitchenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellHeight = CGRectGetHeight(collectionView.frame) - (Constants.orderCollectionViewCellTopInset + Constants.orderCollectionViewCellBottomInset)
        let cellWidth = cellHeight * Constants.orderCollectionViewCellRatio
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
