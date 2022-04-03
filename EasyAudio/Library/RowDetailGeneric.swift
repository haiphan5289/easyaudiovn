//
//  RowDetailGeneric.swift
//  Dayshee
//
//  Created by haiphan on 10/31/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import Foundation
import Eureka

protocol UpdateDisplayProtocol {
    associatedtype Value
    func setupDisplay(item: Value?)
}
typealias SelectCallback = (Int) -> Void
protocol CallbackSelectProtocol {
    func set(callback: SelectCallback?)
}

// MARK: - Generic detail
final class RowDetailGeneric<C>: Row<C>, RowType where C: BaseCell, C: CellType, C: UpdateDisplayProtocol {

    func set(callback: SelectCallback?) {
        guard let c = cell as? CallbackSelectProtocol else { return }
        c.set(callback: callback)
    }
    
    @discardableResult
    func onChange(_ callback: @escaping (RowDetailGeneric<C>) -> Void) -> RowDetailGeneric<C> {
        return self
    }
   
}
