//
//  ViewController.swift
//  WCLWaterFallLayout
//
//  Created by 王崇磊 on 2016/12/21.
//  Copyright © 2016年 王崇磊. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
                      UICollectionViewDataSource,
                      WCLWaterFallLayoutDelegate,
                      UICollectionViewDelegate {

    var dataCount = 20
    var columnCount = 2
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        (collectionView.collectionViewLayout as? WCLWaterFallLayout)?.delegate = self
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        defer {
            collectionView.reloadData()
        }
        if sender.selectedSegmentIndex == 1 {
            dataCount   = 30
            columnCount = 3
        }else {
            dataCount   = 20
            columnCount = 2
        }
    }
    
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Identifier", for: indexPath)
        cell.contentView.backgroundColor    = [UIColor.blue, UIColor.red, UIColor.yellow][indexPath.row % 3]
        cell.contentView.clipsToBounds      = true
        cell.contentView.layer.cornerRadius = 5
        return cell
    }
    
    //MARK: WCLWaterFallLayoutDelegate
    func waterFall(_ collectionView: UICollectionView, layout waterFallLayout: WCLWaterFallLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let height = 200 + arc4random() % 100
        return CGFloat(height)
    }
    
    func columnOfWaterFall(_ collectionView: UICollectionView) -> Int {
        return columnCount
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

