//
//  PostboxState.swift
//  RxCellError
//
//  Created by Rezuan Bidzhiev on 16.03.2022.
//

import Foundation

struct State<Element: Comparable> {
  var items: [Element] = []
  
  init(items: [Element]) {
    self.items = items
  }
  
  func execute(newItem: Element) -> State {
    var items = self.items

    if items.isEmpty {
      items.append(newItem)
    } else {
      let sourceIndex = ifExists(item: newItem)
            
      if let sourceIndex = sourceIndex {
        items.remove(at: sourceIndex.row)
      }
      
      let destinationIndex = indexPath(for: newItem, in: items)
      
      items.insert(newItem, at: destinationIndex.row)
  
    }
    return State(items: items)
  }
  
  func ifExists(item: Element) -> IndexPath? {
    
    guard let index = items.firstIndex(where: {$0 == item}) else { return nil}
    
    return IndexPath(row: index, section: 0)
  }
  
  func indexPath(for newItem: Element, in items: [Element]) -> IndexPath {
    if items.count == 0 {
      return IndexPath(row: 0, section: 0)
    }
    for i in 0..<items.count {
      let item = items[i]
      if newItem > item {
        return IndexPath(row: i, section: 0)
      }
    }
    
    return IndexPath(row: items.count, section: 0)
  }
}

func + <T>(lhs: [T], rhs: T) -> [T] {
  var copy = lhs
  copy.append(rhs)
  return copy
}
