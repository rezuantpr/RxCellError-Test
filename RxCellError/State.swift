//
//  PostboxState.swift
//  RxCellError
//
//  Created by Rezuan Bidzhiev on 16.03.2022.
//

import Foundation

struct State<Element: Comparable> {
  var items: [Element]
  
  mutating func update(newItem: Element) {
    if let index = items.firstIndex(where: { $0 == newItem }) {
      items.remove(at: index)
    }
    items.insert(newItem, at: items.firstIndex(where: { newItem > $0 }) ?? items.count)
  }
}
