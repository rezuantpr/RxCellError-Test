//
//  ViewController.swift
//  RxCellError
//
//  Created by Rezuan Bidzhiev on 16.03.2022.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ViewController: UIViewController {
  var disposeBag = DisposeBag()
  lazy var dataSource = makeDataSource()
  
  let tableView = UITableView()
  
  let viewModel = ViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(tableView)
    tableView.register(Cell.self, forCellReuseIdentifier: Cell.description())
    bindViewModel()
  }
  
  func bindViewModel() {
    let output = viewModel.transform(from: .init())
    
    output.sections
      .drive(tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    tableView.frame = view.safeAreaLayoutGuide.layoutFrame
  }

  func makeDataSource() -> RxTableViewSectionedAnimatedDataSource<SectionModel> {
    .init { _, tableView, indexPath, item in
      switch item {
      case .timer(let cellViewModel):
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.description(), for: indexPath) as! Cell
        cell.bind(to: cellViewModel)
        return cell
      }
    }
  }

}

