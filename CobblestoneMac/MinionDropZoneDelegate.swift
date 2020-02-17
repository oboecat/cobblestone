//
//  MinionDropZone.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/29/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import Foundation

class MinionDropZoneDelegate: NSObject, DropZoneDelegate, ObservableObject {
    var index: Int
    @Published var isHovered = false

    init(index: Int) {
        self.index = index
    }

    func isInterested(data: Any) -> Bool {
        return data is Card
    }

    func onDrop(data: Any) {
        let card = data as! Card
        
        isHovered = false
        print("dropped \(card.name)")
    }

    func hoverEntered(data: Any) {
        let card = data as! Card
        
        isHovered = true
        
        DispatchQueue.main.async {
            print("hovered \(card.name)")
        }
    }
    
    func hoverExited() {
        isHovered = false
        print("exited drop zone \(index)")
    }
}
