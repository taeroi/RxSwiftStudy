//
//  MemoDetailViewController.swift
//  RxMemoTutorial
//
//  Created by 태로고침 on 2021/04/22.
//

import UIKit
import RxSwift
import RxCocoa

class MemoDetailViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MemoDetailViewModel!
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx_disposeBag)
        
        //subject가 업데이트된 내용을 다시 방출하게끔 해야함
        viewModel.contents
            .bind(to: listTableView.rx.items){ tableView, row, value in
                switch row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")!
                    cell.textLabel?.text = value
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell")!
                    cell.textLabel?.text = value
                    return cell
                default:
                    fatalError()

                }
            }
            .disposed(by: rx_disposeBag)
        
        //이렇게 구현을 할 수도 있지만 어거지로 한 느낌 -> 동작이 부자연스러움
        //        var backButton = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
        //        viewModel.title
        //            .drive(backButton.rx.title)
        //            .disposed(by: rx_disposeBag)
        //        backButton.rx.action = viewModel.popAction
        //        navigationItem.backBarButtonItem = backButton
        
        editButton.rx.action = viewModel.makeEditAction()
        
        deleteButton.rx.action = viewModel.makeDeleteAction()
        
        shareButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                guard let memo = self?.viewModel.memo.content else {return}
                
                let vc = UIActivityViewController(activityItems: [memo],
                                                  applicationActivities: nil)
                self?.present(vc, animated: true, completion: nil)
            })
            .disposed(by: rx_disposeBag)
    }
    
}
