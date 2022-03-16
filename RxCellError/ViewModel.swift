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
  typealias Identity = String
  
  var identity: String {
    switch self {
    case .timer(let cellViewModel):
      return "\(cellViewModel.id)"
    }
  }
  
  case timer(CellViewModel)
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.identity == rhs.identity
  }
}

struct SectionModel: AnimatableSectionModelType {
  var title: String
  var items: [Item]
  
  var identity: String { title }
  
  typealias Item = ItemModel
  
  init(original: Self, items: [Item]) {
    self = original
    self.items = items
  }
  
  init(title: String, items: [Item]) {
    self.title = title
    self.items = items
  }
}

class ViewModel: NSObject {
  var disposeBag = DisposeBag()
  
  struct Input { }
  
  struct Output {
    var sections: Driver<[SectionModel]>
  }
  
  let sections = BehaviorSubject<[SectionModel]>(value: [])

  func transform(from input: Input) -> Output {

    let sections = self.sections.asDriver(onErrorJustReturn: [])
      .startWith([])
    
    let initialState = State<Int>(items: [])
    
    let itemsMainSource = Observable.just([1,2])
      .observe(on: MainScheduler.instance)
      .flatMapLatest { Observable.from($0)}

    let anotherSource: Observable<Int> = .empty()
    
    let items = Observable.merge(itemsMainSource, anotherSource)
      .scan(initialState) { state, item in
        return state.execute(newItem: item)
      }
      .map { $0.items }
      
    items
      .observe(on: MainScheduler.asyncInstance)
      .flatMapLatest { items -> Observable<[ItemModel]> in
        let itemModels = items.map { item in
          ItemModel.timer(CellViewModel(id: item))
        }
        return .just(itemModels)
      }
      .map {
        [SectionModel(title: "title", items: $0)]
      }
      .bind(to: self.sections)
      .disposed(by: disposeBag)
        
    return Output(sections: sections)
  }
}
