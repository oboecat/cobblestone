//
//  MinionPlacementView.swift
//  CobblestoneMac
//
//  Created by Lila Pustovoyt on 11/8/19.
//  Copyright © 2019 Lila Pustovoyt. All rights reserved.
//

import SwiftUI

struct MinionPlacementView: View {
    @ObservedObject var dropZone: MinionDropZoneDelegate
//    @State var isTargeted = false
    var index: Int
//    @State var dropLocation: CGPoint = .zero
    
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 140, height: 144)
//            .padding(.horizontal, isTargeted ? -10 : -60)
            .padding(.horizontal, dropZone.isHovered ? -10 : -60)
    }
}

struct MinionPlacementView_Previews: PreviewProvider {
    static var previews: some View {
        MinionPlacementView(dropZone: MinionDropZoneDelegate(index: 1), index: 0)
    }
}
