//
//  ViewController.swift
//  WaitersApp
//
//  Created by Yuriy Sirko on 2/1/16.
//  Copyright © 2016 ThinkMobiles. All rights reserved.
//

import UIKit

struct DraggableCell {
    static var placeholderView: UIView!
    static var indexPath: NSIndexPath!
}

class WTSKitchenViewController: UIViewController {
    
    @IBOutlet weak var tablesTableView: UITableView!
    @IBOutlet weak var orderDetailTableView: UITableView!
    @IBOutlet weak var ordersCollectionView: UICollectionView!
    
    var dataSource : [Int] = []
    var currentTableNumber: Int = 0
    var currentOrder: Int = -1
    
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
        currentOrder += 1
        if currentOrder + 1 > dataSource[currentTableNumber] {
            Utils.showAlertWithMessage("You are done")
            return
        }
        selectOrederAtIndex(currentOrder)
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
        guard let path = ordersCollectionView.indexPathForItemAtPoint(location) else {
            return
        }
        
        switch (gesture.state) {
         case .Began:
            guard let cell = ordersCollectionView.cellForItemAtIndexPath(path) else {
                return
            }
            
            var center = cell.center
            let snapshot = snapshotOfTheView(cell)
            let placeholder = UIImageView(image: snapshot)
            placeholder.alpha = 0.5
            placeholder.center = center
            DraggableCell.indexPath = path
            DraggableCell.placeholderView = placeholder
            
            ordersCollectionView.addSubview(DraggableCell.placeholderView)
            
            UIView.animateWithDuration(0.25, animations: {
                cell.alpha = 0
                center.x = location.x
                DraggableCell.placeholderView.center = center
                DraggableCell.placeholderView.transform = CGAffineTransformMakeScale(1.05, 1.05)
                DraggableCell.placeholderView.alpha = 0.95
            }, completion: { (_) in
                cell.hidden = true
            })

         case .Changed:
            if var center = DraggableCell.placeholderView?.center {
                center.x = location.x
                DraggableCell.placeholderView.center = center
                
                if path != DraggableCell.indexPath {
                    //swap(&dataSource[path.row], &dataSource[DraggableCell.indexPath.row])
                    ordersCollectionView.moveItemAtIndexPath(DraggableCell.indexPath, toIndexPath: path)
                    DraggableCell.indexPath = path
                }
            }
         default:
            guard let path = DraggableCell.indexPath, let cell = ordersCollectionView.cellForItemAtIndexPath(path) else {
                return
            }
            cell.alpha = 0
            cell.hidden = false
            
            UIView .animateWithDuration(0.25, animations: {
                DraggableCell.placeholderView.center = cell.center
                DraggableCell.placeholderView.transform = CGAffineTransformIdentity
                DraggableCell.placeholderView.alpha = 0
                cell.alpha = 1
            }, completion: { (_) in
                DraggableCell.placeholderView.removeFromSuperview()
                DraggableCell.indexPath = nil
                DraggableCell.placeholderView = nil
            })
         }
    }
    
    func snapshotOfTheView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot
    }
    
    func selectOrederAtIndex(index: Int) {
        let path = NSIndexPath.init(forRow: currentOrder, inSection: 0)
        ordersCollectionView.selectItemAtIndexPath(path, animated: true, scrollPosition: UICollectionViewScrollPosition.Right)
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
        currentOrder = -1
        currentTableNumber = indexPath.row
        ordersCollectionView.reloadData()
        let path = NSIndexPath.init(forRow: 0, inSection: 0)
        ordersCollectionView.scrollToItemAtIndexPath(path, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
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
