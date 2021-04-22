//
//  MemoDetailViewModel.swift
//  RxMemoTutorial
//
//  Created by 태로고침 on 2021/04/22.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoDetailViewModel: CommonViewModel {
    let memo: Memo
    
    private var formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "Ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
    
    //메모 내용은 tableview에 표시됨(첫 번째 셀에는 메모 내용, 두 번째 셀에는 날짜가 표시됨)
    //내용을 표현할 때는 observable 바인딩하고 2개이기 때문에 이렇게 문자열 배열을 방출
    //그냥 observable로도 가능한데, why behavior subject? 메모 편집 후 다시 돌아오면 새로운 내용이 보여야 함(갱신되어야 함)
    var contents: BehaviorSubject<[String]>
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.memo = memo
        
        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertDate)
        ])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
//    lazy var popAction = CocoaAction { [unowned self] in
//        return self.sceneCoordinator.close(animated: true).asObservable().map{_ in}
//    }
}
