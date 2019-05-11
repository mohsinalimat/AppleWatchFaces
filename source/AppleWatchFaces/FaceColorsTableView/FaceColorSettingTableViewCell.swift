//
//  ColorSettingsTableViewCell.swift
//  AppleWatchFaces
//
//  Created by Michael Hill on 11/7/18.
//  Copyright © 2018 Michael Hill. All rights reserved.
//

import UIKit
import SpriteKit

class FaceColorSettingsTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var faceColorSelectionCollectionView: UICollectionView!
    public var colorList : [String] = []
    var colorIndex = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadColorList(addImages: true)
    }
    
    func colorListVersion( unfilteredColor: String ) -> String {
        //debugPrint("unnfiltered:" + unfilteredColor)
        //TODO: add #
        let colorListVersion = unfilteredColor.lowercased()
        //keep only first 6 chars
        let colorListVersionSubString = String(colorListVersion.prefix(9))
        
        //should be
        //#d8fff8ff
        
        //debugPrint("filtered:" + colorListVersionSubString)
        
        return colorListVersionSubString
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //NOTE: 99 is the total size
        if AppUISettings.materialIsColor(materialName: colorList[indexPath.row] ) {
            return CGSize.init(width: 33, height: 33)
        } else {
            return CGSize.init(width: 99*0.8, height: 99)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingsColorCell", for: indexPath) as! ColorSettingCollectionViewCell
        
        //buffer
        let buffer:CGFloat = CGFloat(Int(cell.frame.size.width / 10))
        let corner:CGFloat = CGFloat(Int(buffer / 2))
        cell.circleView.frame = CGRect.init(x: corner, y: corner, width: cell.frame.size.width-buffer, height: cell.frame.size.height-buffer)
        
        if AppUISettings.materialIsColor(materialName: colorList[indexPath.row] ) {
            cell.circleView.layer.cornerRadius = cell.circleView.frame.height / 2
            cell.circleView.backgroundColor = SKColor.init(hexString: colorList[indexPath.row] )
        } else {
            if let image = UIImage.init(named: colorList[indexPath.row] ) {
                cell.circleView.layer.cornerRadius = 0
                //TODO: if this idea sticks, resize this on app start and cache them so they arent built on-demand
                let scaledImage = AppUISettings.imageWithImage(image: image, scaledToSize: CGSize.init(width: cell.frame.size.width-buffer, height: cell.frame.size.height-buffer))
                cell.circleView.backgroundColor = SKColor.init(patternImage: scaledImage)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let newColor = colorList[indexPath.row]
//
//        //add to undo stack for actions to be able to undo
//        SettingsViewController.addToUndoStack()
//
//        //update the value
//        SettingsViewController.currentClockSetting.clockFaceMaterialName = newColor
//        NotificationCenter.default.post(name: SettingsViewController.settingsChangedNotificationName, object: nil, userInfo:nil)
//        NotificationCenter.default.post(name: WatchSettingsTableViewController.settingsTableSectionReloadNotificationName, object: nil,
//                                        userInfo:["cellId": self.cellId , "settingType":"clockFaceMaterialName"])
    }
    
    // MARK: - Utility functions
    
    // load colors from Colors.plist and save to colorList array.
    func loadColorList(addImages:Bool) {
        // create path for Colors.plist resource file.
        let colorFilePath = Bundle.main.path(forResource: "Colors", ofType: "plist")
        
        // save piist file array content to NSArray object
        let colorNSArray = NSArray(contentsOfFile: colorFilePath!)
        
        // Cast NSArray to string array.
        colorList = colorNSArray as! [String]
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
