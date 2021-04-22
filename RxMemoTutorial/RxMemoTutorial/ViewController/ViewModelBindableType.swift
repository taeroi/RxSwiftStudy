//
//  ViewModelBindableType.swift
//  RxMemoTutorial
//
//  Created by 태로고침 on 2021/04/22.
//

import UIKit

protocol ViewModelBindableType {
    //view model의 type은 VC마다 달라지기 때문에 protocol을 제네릭으로 선언
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! {get set}
    func bindViewModel()
}

//VC에 추가된 view model속성에 실제의 view model을 저장, bind view model 메소드를 자동으로 호출하는 메소드를 구현
extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        bindViewModel()
    }
}
