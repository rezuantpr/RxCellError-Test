//
//  ViewModel.swift
//  RxCellError
//
//  Created by Rezuan Bidzhiev on 16.03.2022.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa

struct ItemModel: IdentifiableType, Equatable {
  let identity: Int
}

typealias SectionModel = AnimatableSectionModel<String, ItemModel>

final class ViewModel {
  struct Input { }
  
  struct Output {
    var sections: Driver<[SectionModel]>
  }
  
  func transform(from input: Input) -> Output {

    let initialState = State<Int>(items: [])
    
    let itemsMainSource = Observable.just([1,2])
      .observe(on: MainScheduler.instance)
      .flatMapLatest { Observable.from($0) }

    let anotherSource: Observable<Int> = .empty()
    
    let items = Observable.merge(itemsMainSource, anotherSource)
      .scan(into: initialState) { state, item in
        state.update(newItem: item)
      }
      .map { $0.items }

    let sections = items
      .map { $0.map(ItemModel.init) }
      .map {
        [SectionModel(model: "title", items: $0)]
      }
      .startWith([])
      .asDriver(onErrorJustReturn: [])

    return Output(sections: sections)
  }
}
