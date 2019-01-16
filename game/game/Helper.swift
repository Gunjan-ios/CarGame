//
//  Helper.swift
//  game
//
//  Created by Gunjan on 13/12/18.
//  Copyright © 2018 Parkland. All rights reserved.
//

import Foundation
import UIKit

struct  colliderType {
    static let CAR_COLLIDER : UInt32 = 0
    static let ITEM_COLLIDER : UInt32 = 1
    static let  ITEM_COLLIDER1  : UInt32 = 2
    
    
}

class Helper: NSObject {
    
    func randomBetweenTwonumbers(firstnumber : CGFloat , secondnumber :CGFloat) -> CGFloat  {
         return CGFloat(arc4random())/CGFloat(UINT32_MAX)  * abs(firstnumber-secondnumber) + min(firstnumber, secondnumber)
    }
}
    class settings {
         static let sharedInstance = settings()
        
        private init(){
        }
        var highScore = 0
        
    }
    
    
    
    
    
    
    
    
