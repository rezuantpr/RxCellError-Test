//
//  CellViewModel.swift
//  RxCellError
//
//  Created by Rezuan Bidzhiev on 16.03.2022.
//

import Foundation
import RxCocoa
import RxSwift

final class CellViewModel {
  struct Input {
    let model: ItemModel
  }

  struct Output {
    let id: Int
    let seq: Driver<Int>
  }

  func transform(from input: Input) -> Output {
    let id = input.model.identity
    let seq = Observable<Int>.timer(
      .seconds(1),
      period: .seconds(1),
      scheduler: SerialDispatchQueueScheduler(qos: .userInteractive)
    )
      .map { _ in Int.random(in: 0...9) }
      .asDriver(onErrorJustReturn: -1)
    return Output(id: id, seq: seq)
  }
}
