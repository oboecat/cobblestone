//
//  DragAndDrop.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/19/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import Foundation
import SwiftUI

class DragAndDrop: ObservableObject {
    struct Destination {
        var frame: CGRect
        var delegate: DropZoneDelegate
    }
    
    var destinations = [Destination]()
    var interestedDestinations: [Destination]?
    var data: Any?
    var dragValue: DragGesture.Value?
    var currentTarget: Destination?
    
    func dragStarted(data: Any) {
        self.data = data
        interestedDestinations = destinations.filter { $0.delegate.isInterested(data: data) }
    }
    
    func dragUpdated(value: DragGesture.Value) {
        self.dragValue = value
        
        if let lastKnownTarget = currentTarget {
            if lastKnownTarget.frame.contains(value.location) {
                lastKnownTarget.delegate.hoverMoved?(data: data!, location: value.location)
                return
            } else {
                lastKnownTarget.delegate.hoverExited?()
            }
        }
        
        if let dropZone = interestedDestinations?.first(where: { $0.frame.contains(value.location) }) {
            currentTarget = dropZone
            dropZone.delegate.hoverEntered?(data: self.data!)
        } else {
            currentTarget = nil
        }
    }
    
    func dragEnded(value: DragGesture.Value) {
        if let dropZone = currentTarget, dropZone.frame.contains(value.location) {
            dropZone.delegate.onDrop?(data: self.data!)
        }
        
        data = nil
        dragValue = nil
        interestedDestinations = nil
        currentTarget = nil
    }
    
    func registerDropZone(frame: CGRect, delegate: DropZoneDelegate) {
        destinations.append(Destination(frame: frame, delegate: delegate))
    }
    
    func deregisterDropZone(delegate: DropZoneDelegate) {
        destinations.removeAll {
            $0.delegate === delegate
        }
    }
}
