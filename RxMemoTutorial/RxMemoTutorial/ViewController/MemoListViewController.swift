//
//  MemoListViewController.swift
//  RxMemoTutorial
//
//  Created by 태로고침 on 2021/04/22.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MemoListViewModel!
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //View Model과 View를 바인딩
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx_disposeBag)
        
        //메모 목록을 tableview에 바인딩
        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { row, memo, cell in
                cell.textLabel?.text = memo.content
            }
            .disposed(by: rx_disposeBag)
        
        addButton.rx.action = viewModel.makeCreateAction()
        
        //선택된 메모와 indexPath가 튜플 형태로 방출됨
        Observable.zip(listTableView.rx.modelSelected(Memo.self), listTableView.rx.itemSelected)
            .do(onNext: {[unowned self] (_, indexPath) in
                    self.listTableView.deselectRow(at: indexPath, animated: true)})
            .map {$0.0}
            .bind(to: viewModel.detailAction.inputs)
            .disposed(by: rx_disposeBag)
        
        //nav bar의 기본 back button의 동작을 변경한다고 달라지지 않음
//        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
//        viewModel.title
//            .drive(backButton.rx.title)
//            .disposed(by: rx_disposeBag)
//        backButton.rx.action = viewModel.popAction
//        navigationItem.backBarButtonItem = backButton
    }
}
