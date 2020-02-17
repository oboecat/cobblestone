//
//  DraggableViewModifier.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/21/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct DraggableViewModifier: ViewModifier {
    
    enum DragState {
        case inactive
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive:
                return false
            case .dragging:
                return true
            }
        }
    }
    
    @Binding var card: Card
    @EnvironmentObject var manager: DragAndDrop
    @GestureState var dragState = DragState.inactive
    
    func body(content: _ViewModifier_Content<DraggableViewModifier>) -> some View {
        content
            .offset(dragState.translation)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .updating($dragState) { value, state, _ in
                        // drag just started
                        if !state.isDragging {
                            self.manager.dragStarted(data: self.card)
                        }
                        
                        self.manager.dragUpdated(value: value)
                        
                        state = .dragging(translation: CGSize(
                            width: value.translation.width,
                            height: -value.translation.height)
                        )
                    }
                    .onEnded { value in
                        self.manager.dragEnded(value: value)
                    }
            )
    }
}

extension View {
    func draggable(card: Binding<Card>) -> some View {
        self.modifier(DraggableViewModifier(card: card))
    }
}
