//
//  Cell.swift
//  RxCellError
//
//  Created by Rezuan Bidzhiev on 16.03.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class Cell: UITableViewCell {
  private (set) var disposeBag = DisposeBag()
  private let viewModel = CellViewModel()

  func bind(to itemModel: ItemModel) {

    let input = CellViewModel.Input(model: itemModel)
    let output = viewModel.transform(from: input)

    output.seq
      .observe(on: MainScheduler.instance)
      .bind(onNext: { [unowned self] value in
        print("Cell-\(output.id); value = \(value)")
        textLabel?.text = "Cell-\(output.id); value = \(value)"
      })
      .disposed(by: disposeBag)

    textLabel?.text = "\(output.id)"
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
}
