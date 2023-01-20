//
//  Layer+Extension.swift
//  ManageFiles
//
//  Created by haiphan on 07/08/2022.
//

import Foundation
import QuartzCore

public extension CALayer {
    
    enum Corner {
        case verticalTop, verticalBot
    }
    func setCornerRadius(corner: Corner, radius: CGFloat) {
        switch corner {
        case .verticalTop:
            self.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .verticalBot:
            self.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        self.cornerRadius = radius
    }
}
