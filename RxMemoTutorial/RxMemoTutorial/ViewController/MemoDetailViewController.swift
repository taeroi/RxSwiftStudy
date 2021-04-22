//
//  MemoDetailViewController.swift
//  RxMemoTutorial
//
//  Created by 태로고침 on 2021/04/22.
//

import UIKit

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
        
    }

}
