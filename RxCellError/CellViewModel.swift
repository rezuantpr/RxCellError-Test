//
//  CellViewModel.swift
//  RxCellError
//
//  Created by Rezuan Bidzhiev on 16.03.2022.
//

import Foundation
import RxSwift
import RxCocoa

class CellViewModel: NSObject {
  var disposeBag = DisposeBag()
  
  var id: Int
  
  var seq = PublishRelay<Int>()
  
  init(id: Int) {
    self.id = id
    super.init()
    
    Observable<Int>.timer(.seconds(1), period: .seconds(1), scheduler: SerialDispatchQueueScheduler(qos: .userInteractive))
      .map { _ in Int.random(in: 0...9)}
      .bind(to: seq)
      .disposed(by: disposeBag)
  }
  
  deinit {
    print("CellViewModel-\(id) has been released")
  }
}
