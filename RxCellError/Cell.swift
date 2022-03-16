//
//  Cell.swift
//  RxCellError
//
//  Created by Rezuan Bidzhiev on 16.03.2022.
//

import UIKit
import RxSwift
import RxCocoa

class Cell: UITableViewCell {
  var disposeBag = DisposeBag()
  
  func bind(to viewModel: CellViewModel) {
    let id = viewModel.id
    
    viewModel.seq.asDriver(onErrorJustReturn: -1)
      .drive(onNext: { [unowned self] value in
        print("Cell-\(id); value = \(value)")
        textLabel?.text = "Cell-\(id); value = \(value)"
      })
      .disposed(by: disposeBag)
    
    textLabel?.text = viewModel.id.description
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
}
