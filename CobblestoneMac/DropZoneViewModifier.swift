//
//  DropZoneViewModifier.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/21/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct DropZoneViewModifier: ViewModifier {
    var delegate: DropZoneDelegate
    @EnvironmentObject var manager: DragAndDrop
    
    func body(content: Content) -> some View {
        content
            .overlay(GeometryReader { geo in
                Rectangle()
                    .stroke(Color.green)
                    .onAppear {
                        self.manager.registerDropZone(
                            frame: geo.frame(in: .global),
                            delegate: self.delegate)
                    }
                    .onDisappear {
                        self.manager.deregisterDropZone(delegate: self.delegate)
                    }
                }
            )
    }
//
//    func isInterested(data: Any) -> Bool {
//        return data is Card
//    }
//
//    func onDrop(data: Any) {
//        let card = data as! Card
//        print("dropped \(card.name)")
//    }
//
//    func hoverEntered(data: Any) {
//        let card = data as! Card
//
//        DispatchQueue.main.async {
//            self.onHover()
//        }
//
//        print("hovered \(card.name)")
//    }
//
//    func hoverMoved(data: Any, location: CGPoint) {
////        var card = data as! Card
//    }
//
//    func hoverExited() {
//        print("hover exited")
//        DispatchQueue.main.async {
//            self.onHoverExit()
//        }
//    }
}

extension View {
    func dropZone(delegate: DropZoneDelegate) -> some View {
        self.modifier(DropZoneViewModifier(delegate: delegate))
    }
}
