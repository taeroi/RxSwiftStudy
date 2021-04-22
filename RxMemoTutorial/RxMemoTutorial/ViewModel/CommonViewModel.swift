//
//  CommonViewModel.swift
//  RxMemoTutorial
//
//  Created by 태로고침 on 2021/04/22.
//

import Foundation
import RxSwift
import RxCocoa

class CommonViewModel: NSObject {
    //이렇게 하면 navigtaion에 쉽게 binding 할 수 있음
    let title: Driver<String>
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoStorageType
    
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType){
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}

