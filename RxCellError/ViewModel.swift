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

enum ItemModel: IdentifiableType, Equatable {
  var identity: Int {
    switch self {
    case .timer(let cellViewModel):
      return cellViewModel.id
    }
  }
  
  case timer(CellViewModel)
}

typealias SectionModel = AnimatableSectionModel<String, ItemModel>

class ViewModel: NSObject {
  struct Input { }
  
  struct Output {
    var sections: Driver<[SectionModel]>
  }
  
  let sections = BehaviorSubject<[SectionModel]>(value: [])

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
      .observe(on: MainScheduler.asyncInstance)
      .flatMapLatest { items -> Observable<[ItemModel]> in
        let itemModels = items.map { item in
          ItemModel.timer(CellViewModel(id: item))
        }
        return .just(itemModels)
      }
      .map {
        [SectionModel(model: "title", items: $0)]
      }
      .startWith([])
      .asDriver(onErrorJustReturn: [])

    return Output(sections: sections)
  }
}
