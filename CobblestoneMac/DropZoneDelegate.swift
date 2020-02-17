//
//  DropZoneDelegate.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/29/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import Foundation

@objc protocol DropZoneDelegate {
    func isInterested(data: Any) -> Bool
    
    @objc optional func onDrop(data: Any) -> Void
        
    @objc optional func hoverEntered(data: Any) -> Void
    
    @objc optional func hoverMoved(data: Any, location: CGPoint) -> Void
    
    @objc optional func hoverExited() -> Void
}

//extension DropZoneDelegate {
//    func onDrop(data: Any) {
//        // default
//    }
//
//    func hoverEntered(data: Any) {
//        // default
//    }
//
//    func hoverMoved(data: Any, location: CGPoint) {
//        // default
//    }
//
//    func hoverExited() {
//        // default
//    }
//}
