//
//  CardTableViewCell.swift
//  yugioh
//
//  Created by Aaron on 25/9/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class CardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellContentInnerView: UIView!
    @IBOutlet weak var card: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var effect: UIVerticalAlignLabel!
    @IBOutlet weak var star: UIButton!
    @IBOutlet weak var attack: UILabel!
    
    private let service = CardService()
    
    func prepare(cardEntity: CardEntity, tableView: UITableView, indexPath: IndexPath) {
        
        let img = UIImage(named: "ic_star_white")?.withRenderingMode(.alwaysTemplate)
        star.setImage(img, for: .normal)
        if cardEntity.isSelected {
            star.tintColor = yellowColor
        } else {
            star.tintColor = greyColor
        }
        star.addTarget(self, action: #selector(CardTableViewCell.clickStarButton(sender:)), for: .touchUpInside)
        star.cardEntity = cardEntity
        cellContentView.backgroundColor = greyColor
        cellContentInnerView.backgroundColor = UIColor.white
        
        
        self.title.text = cardEntity.title
        self.effect.text = cardEntity.effect
        if cardEntity.star.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            self.type.text = cardEntity.type + " (" + cardEntity.star + "星)"
        } else {
            self.type.text = cardEntity.type
        }
        if cardEntity.attack.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 && cardEntity.defense.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            self.attack.text = cardEntity.attack + " / " + cardEntity.defense
        } else {
            self.attack.text = ""
        }
        
        
    }
    
    
    func clickStarButton(sender: UIButton) {
        let cardEntity = sender.cardEntity
        
        if sender.tintColor == greyColor {
            sender.tintColor = yellowColor
            cardEntity.isSelected = true
        } else {
            //delete
            sender.tintColor = greyColor
            cardEntity.isSelected = false
        }
        nc.post(name: Notification.Name("clickStarButton"), object: nil, userInfo: ["data": cardEntity])
        
    }
    
}

fileprivate var key: UInt8 = 0

fileprivate extension UIButton {
    var cardEntity: CardEntity {
        get {
            return objc_getAssociatedObject(self, &key) as! CardEntity
        }
        
        set(value) {
            objc_setAssociatedObject(self, &key, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}